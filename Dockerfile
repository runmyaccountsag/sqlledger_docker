FROM centos:centos8

# FROM ubuntu:20.04


RUN useradd -ms /home/testuser testuser
RUN usermod -aG root testuser
WORKDIR /home/testuser


RUN yum -y install glibc-locale-source glibc-langpack-en
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

RUN yum -y update
RUN yum -y install postgresql
RUN yum -y install perl
RUN yum -y install git
RUN yum -y install httpd
COPY httpd.conf /etc/httpd/conf/httpd.conf



# Set Config for ledger


# Ubuntu Stuff
# RUN apt-get update
# RUN apt-get install git -y
# RUN apt-ge





# USER testuser
RUN git clone https://github.com/ledger123/runmyaccounts.git runmyaccounts
RUN mkdir runmyaccounts/users
RUN mkdir runmyaccounts/spool
RUN touch runmyaccounts/users/members
RUN printf "[root login]\npassword=1234\n" > runmyaccounts/users/members
# RUN mkdir -p Sites/
RUN mkdir /var/www/rma
RUN ln -s runmyaccounts/ /var/www/rma/runmyaccounts
# RUN cp -r /home/testuser/runmyaccounts /var/www/rma/

# RUN /usr/sbin/httpd




RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN /usr/sbin/httpd
RUN yum install perl-DBI.x86_64 -y
RUN yum install perl-Time-ParseDate.noarch -y


RUN yum install perl-TimeDate.noarch -y
RUN dnf -y install dnf-plugins-core

RUN dnf config-manager --set-enabled powertools
RUN dnf repolist
RUN yum install perl-JSON-XS.x86_64 -y
RUN yum install perl-File-Slurper.noarch -y
RUN yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
RUN yum install perl-List-MoreUtils.noarch -y
RUN perl -MCPAN -e 'install Text::Markdown'
RUN yum install perl-DBD-Pg.x86_64 -y