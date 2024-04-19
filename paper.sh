# 缓存清除脚本

work_path=/home/you/go/src/github.com/hyperledger/fabric/scripts/fabric-samples/commercial-paper

# 颜色输出
# 成功 -- 绿色
function g(){
    echo -e "\e[32m [ $1 ] $2 \e[0m"
}
# 失败 -- 红色
function r(){
    echo -e "\e[31m [ $1 ] $2 \e[0m"
}
# 未知状态 -- 蓝色
function b(){
    echo -e "\e[96m [ $1 ] $2 \e[0m"
}



function startUSER(){
    cd $work_path
    ./network-starter.sh
}
function stopUSER(){
    cd $work_path
    ./network-clean.sh
}

function delete_clear(){
    b "$1" 检擦是否存在" "node_modules
    cd $2
    ls|grep node
    if [ $? -eq 0 ]; then
        g "$1" node_modules存在，准备删除！
        rm -rf $2/node_modules
        if [ $? -eq 0 ]; then
            g "$1"" --> "删除成功
        else
            r "$1"" --> "删除失败
        fi
    else
        r "$1" node_modules已经删除
    fi
    echo
}

function delete_ident(){
    b "$1" 检擦是否存在" "identity
    cd $2
    ls|grep identity
    if [ $? -eq 0 ]; then
        g "$1" identity存在，准备删除！
        rm -rf $2/identity
        if [ $? -eq 0 ]; then
            g "$1" 删除成功
        else
            r "$1" 删除失败
        fi
    else
        r "$1" node_modules已经删除
    fi
    echo
}

function clearUSER(){
    u1=magnetocorp
    u2=digibank
    delPath1=$work_path/organization/$u1/application
    delPath2=$work_path/organization/$u2/application
    identity=/home/you/go/src/github.com/hyperledger/fabric/scripts/fabric-samples/commercial-paper/organization
    path3=$identity/$u1
    path4=$identity/$u2
    identity_path1=$work_path/organization/$u1
    identity_path2=$work_path/organization/$u2
    
    read -p "确定删除吗？(1 代表同意)" qd
    if [ $qd -eq 1 ]; then
        delete_clear $u1 $delPath1
        delete_ident $u1 $identity_path1
        delete_clear $u2 $delPath2
        delete_ident $u2 $identity_path2
        
    fi
    b docker 检擦缓存
    docker volume ls
    read -p "docker的数据缓存是否为空 (1 代表是)" docker_user_ls
    if [ $docker_user_ls -eq 1 ]; then
        exit
    else
        docker volume rm $(docker volume ls)
    fi
}


# 判断
function ifUSER(){
    if [ $1 -eq 1 ]; then
    	stopUSER
    elif [ $1 -eq 2 ]; then
        startUSER
    elif [ $1 -eq 3 ]; then
        clearUSER
    fi
}


cd $work_path
echo ===============================
echo
echo 1、停止服务
echo 2、开启服务
echo 3、清除缓存
echo
echo ===============================
echo

read -p "输入序号 --> " username
ifUSER $username




