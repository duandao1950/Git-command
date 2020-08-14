# Git-command
Git command

1. git init //初始化仓库
2. git add .(文件name) //添加文件到本地仓库
3. git commit -m "first commit" //添加文件描述信息
4. git remote add origin + 远程仓库地址 //链接远程仓库，创建主分支
5. git pull origin master // 把本地仓库的变化连接到远程仓库主分支
6. git push -u origin master //把本地仓库的文件推送到远程仓库

Updates were rejected because the tip of your current branch is behind
1.使用强制push的方法：
$ git push -u origin master -f
这样会使远程修改丢失，一般是不可取的，尤其是多人协作开发的时候。

