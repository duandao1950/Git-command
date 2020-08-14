
#!/bin/bash
# 背景 使用小程序 版本变更下载到指定目录
# 该脚本 在下载完成版本后 自动移动到指定目录 并完成后台解压覆盖 并启动小程序
prefix_project="gzipdist_"
suffix_file=".zip"
source_path="/c/Users/blll/Downloads"
target_folder="xiaochengxu"
target_path="/d/${target_folder}" #主目标文件目录
target_app_path="/d/${target_folder}/app" #放文件的目录
target_bak_path="/d/${target_folder}/bak" #归档目录
winrar_path="/c/Program*Files/WinRAR"
winrar_exe="winrar.exe"
app_exe="wechatdevtools.exe"
envs=(dev test sit pre prod)

# tasklist|findstr -i "wechatdevtools.exe" 查看 win 下面进程是否启动
cd ${source_path}
init_source_count=`find -name ${prefix_project}*${suffix_file} | wc -l`
if [[ ${init_source_count} > 0 ]]; then
    task_count=`tasklist|findstr -i "${app_exe}" | wc -l`
    echo "Terminate a running program. "${task_count}
    if [[ ${task_count} > 0 ]]; then
        echo "App closed!"
        taskkill //f //im "${app_exe}"
    fi
fi

cd /d
if [[ ! -d ${target_path} ]];then
   mkdir ${target_folder}
fi

echo "Enter the main target file directory: "${target_folder}
cd ${target_path}
#创建放文件的目录
if [[ ! -d ${target_app_path} ]];then
   mkdir app
fi
#创建归档目录
if [[ ! -d ${target_bak_path} ]];then
   mkdir bak
fi
#主归档时间
parent_date=`date +%Y%m%d`
#子归档时间
sub_date=`date "+%Y%m%d%H%M%S"`
#进入放文件的目录
cd ${target_app_path}
for env in ${envs[*]}
do
   source_file=${prefix_project}${env}*${suffix_file}
   # 进入源文件目录 进行校验并移走
   cd ${source_path}
   # 校验源文件是否存在
   source_count=`find -name ${source_file} | wc -l`
   echo "the $env number of files found: "${source_count}
   if [[ ${source_count} > 0 ]]; then
   	  # 进入目标文件夹 创建存放文件的目录
	  cd ${target_app_path}
	  if [[ ! -d ${target_app_path}/${env} ]];then
	   	 mkdir ${env}
	  fi
	  # 进入存放文件的目录
	  cd ${target_app_path}/${env}
	  # 检查之前是否存在
  	  env_count=`find -name ${source_file} | wc -l`
  	  if [[ ${env_count} > 0 ]]; then
  	  	 # 如果存在需要历史归档 创建日期文件夹 存放归档文件
	   	 if [[ ! -d ${target_bak_path}/${parent_date} ]];then
	   	 	cd ${target_bak_path}
		    mkdir ${parent_date}
		 fi
		 # 子归档目录
		 if [[ ! -d ${target_bak_path}/${parent_date}/${sub_date} ]];then
		 	cd ${target_bak_path}/${parent_date}
		    mkdir ${sub_date}
		 fi
		 # 移动文件到子归档目录
	  	 mv ${target_app_path}/${env} ${target_bak_path}/${parent_date}/${sub_date}
  	  fi
  	  # 检查放文件的目录 丢失则创建
  	  if [[ ! -d ${target_app_path}/${env} ]];then
  	  	 cd ${target_app_path}
	   	 mkdir ${env}
	  fi
	  # 移动文件前阻塞 1秒
	  sleep 1
	  # 进入源目标文件夹 查找需要的文件 并移动到指定目录
   	  cd ${source_path}
   	  find -name ${source_file} -type f | xargs -I '{}' mv {} ${target_app_path}/${env}
   	  # 1、源文件进入指定目录后 
   	  # 2、检查文件是否存在 
   	  # 3、如果存在启动 winrar程序 后台自动进行解压 解压前阻塞 1秒
      cd ${target_app_path}/${env}
   	  mv_env_count=`find -name ${source_file} | wc -l`
   	  if [[ ${mv_env_count} > 0 ]]; then
   	  	 sleep 1
	   	 cd ${winrar_path}
	   	 # 后台解压 默认覆盖
	   	 start ${winrar_exe} x -ibck -o+ ${target_app_path}/${env}/${source_file} ${target_app_path}/${env}
	   	 # 打开小程序
	   	 wxdev
   	  fi
   fi
done

cd /d/code/java

echo "over!"
