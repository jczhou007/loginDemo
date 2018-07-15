#!/usr/bin/env bash
#编译+部署myweb站点

#需要配置如下参数
# 项目路径, 在Execute Shell中配置项目路径, pwd 就可以获得该项目路径
# export PROJ_PATH=这个jenkins任务在部署机器上的路径

# 输入你的环境上jetty的全路径
# export JETTY_APP_PATH=tomcat在部署机器上的路径

# 输入你的项目名
# export PROJECT_NAME=

### base 函数
killJetty()
{
    pid=`ps -ef|grep jetty|grep java|awk '{print $2}'`
    echo "jetty Id list :$pid"
    if [ "$pid" = "" ]
    then
      echo "no jetty pid alive"
    else
      kill $pid
    fi
}
cd $PROJ_PATH/$PROJECT_NAME
mvn clean package -Dmaven.skip.test=true

# 停tomcat
killJetty

# 删除原有工程
rm -rf $JETTY_APP_PATH/webapps/ROOT
rm -f $JETTY_APP_PATH/webapps/ROOT.war
rm -f $JETTY_APP_PATH/webapps/$PROJECT_NAME.war

# 复制新的工程
cp $PROJ_PATH/$PROJECT_NAME/target/$PROJECT_NAME.war $JETTY_APP_PATH/webapps/

cd $JETTY_APP_PATH/webapps/
mv $PROJECT_NAME.war ROOT.war

# 启动jetty
cd $JETTY_APP_PATH/
sh bin/jetty.sh start