#!/bin/bash

root_dir=$HOME/data/VOCdataset/
dataset_name=people


# get the current path
bash_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for dataset in trainval test
do
  dst_file=$bash_dir/$dataset.txt
  if [ -f $dst_file ]
  then
    rm -f $dst_file
  fi
  for name in $dataset_name
  do
    echo "Create list for $name $dataset..."
    dataset_file=$root_dir/$name/$dataset.txt

    img_file=$bash_dir/$dataset"_img.txt"
    cp $dataset_file $img_file
    # -i 直接修改读取文件的内容，而不是修改到终端
    # "s/^/X/g" 将所有行的头添加X内容, g表示都需要
    sed -i "s/^/Images\//g" $img_file
    # "s/^/X/g" 将所有行的尾添加X内容, g表示都需要
    sed -i "s/$/.jpg/g" $img_file

    label_file=$bash_dir/$dataset"_label.txt"
    cp $dataset_file $label_file
    sed -i "s/^/Annotations\//g" $label_file
    sed -i "s/$/.xml/g" $label_file

    # paste 用于将多个文件合并， -d 制定不同于tab或者空格的分隔符
    paste -d' ' $img_file $label_file >> $dst_file

    rm -f $label_file
    rm -f $img_file
  done

  # Generate image name and size infomation.
  if [ $dataset == "test" ]
  then
    $bash_dir/../../build/tools/get_image_size $root_dir/$name $dst_file $bash_dir/$dataset"_name_size.txt"
  fi

  # Shuffle trainval file.
  if [ $dataset == "trainval" ]
  then
    rand_file=$dst_file.random
    cat $dst_file | perl -MList::Util=shuffle -e 'print shuffle(<STDIN>);' > $rand_file
    mv $rand_file $dst_file
  fi
done
