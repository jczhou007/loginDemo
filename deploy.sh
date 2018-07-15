#!/usr/bin/env bash
#����+����mywebվ��

#��Ҫ�������²���
# ��Ŀ·��, ��Execute Shell��������Ŀ·��, pwd �Ϳ��Ի�ø���Ŀ·��
# export PROJ_PATH=���jenkins�����ڲ�������ϵ�·��

# ������Ļ�����jetty��ȫ·��
# export JETTY_APP_PATH=tomcat�ڲ�������ϵ�·��

# ���������Ŀ��
# export PROJECT_NAME=

### base ����
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

# ͣtomcat
killJetty

# ɾ��ԭ�й���
rm -rf $JETTY_APP_PATH/webapps/ROOT
rm -f $JETTY_APP_PATH/webapps/ROOT.war
rm -f $JETTY_APP_PATH/webapps/$PROJECT_NAME.war

# �����µĹ���
cp $PROJ_PATH/$PROJECT_NAME/target/$PROJECT_NAME.war $JETTY_APP_PATH/webapps/

cd $JETTY_APP_PATH/webapps/
mv $PROJECT_NAME.war ROOT.war

# ����jetty
cd $JETTY_APP_PATH/
sh bin/jetty.sh start