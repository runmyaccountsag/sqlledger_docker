FROM tgagor/centos:stream8

RUN useradd -ms /home/runmyaccounts rma
RUN usermod -aG root rma

WORKDIR /home/runmyaccounts

RUN yum -y update

RUN yum -y install glibc-locale-source glibc-langpack-en
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

RUN yum -y install postgresql
RUN yum -y install sudo
RUN yum -y install perl
RUN yum -y install git
RUN yum -y install httpd
COPY httpd.conf /etc/httpd/conf/httpd.conf
RUN echo "root:1234" | chpasswd
RUN echo "rma:1234" | chpasswd
RUN echo '%root ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


RUN git clone -b master https://github.com/ledger123/runmyaccounts.git runmyaccounts
RUN mkdir runmyaccounts/users
RUN mkdir runmyaccounts/spool
RUN touch runmyaccounts/users/members
RUN printf "[root login]\npassword=rotwjj.UgUkOw\n" > runmyaccounts/users/members
RUN mkdir /var/www/rma
RUN ln -s /home/runmyaccounts/runmyaccounts /var/www/rma
RUN chmod -R 777 /var/www/rma
RUN chmod -R 777 /home/runmyaccounts/runmyaccounts


# Repositories
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf -y install dnf-plugins-core
RUN dnf -y install gcc
RUN dnf config-manager --set-enabled powertools
RUN dnf repolist

# TODO use versions for depencenies
# Install Perl Modules for ledger
RUN yum install perl-Time-ParseDate.noarch -y
RUN yum install perl-TimeDate.noarch -y
RUN yum install perl-File-Slurper.noarch -y
RUN yum install perl-List-MoreUtils.noarch -y
RUN yum install perl-JSON-XS -y
RUN yum install perl-DBI -y
RUN yum install perl-DBD-Pg -y

RUN cpan Text::Markdown -y
RUN cpan DBIx::Simple -y
RUN cpan SL::Form -y
RUN cpan -fi HTML::Entities -y
RUN cpan -fi HTML::FromText -y

# Below used only for debugging perl
RUN cpan Try::Tiny -y

# requred for PDF (not all are required)
RUN yum makecache -y
RUN yum install texlive-pdftex  -y
RUN yum install texlive-latex-bin -y
RUN yum install texlive-texconfig* -y
RUN yum install texlive-latex* -y
RUN yum install texlive-metafont* -y
RUN yum install texlive-cmap* -y
RUN yum install texlive-ec -y
RUN yum install texlive-fncychap* -y
RUN yum install texlive-pdftex-def -y
RUN yum install texlive-fancyhdr* -y
RUN yum install texlive-titlesec* -y
RUN yum install texlive-multirow -y
RUN yum install texlive-framed* -y
RUN yum install texlive-wrapfig* -y
RUN yum install texlive-parskip* -y
RUN yum install texlive-caption -y
RUN yum install texlive-ifluatex* -y
RUN yum install texlive-collection-fontsrecommended -y
RUN yum install texlive-collection-latexrecommended -y

USER rma

# ENTRYPOINT exec /usr/sbin/httpd && tail -f /dev/null
# ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
