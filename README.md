# tm
> time manage inspire by zoejane/tm.zoejane.net

## Background
> 使用 aTimeLogger2 7年了, 才发现这是个大坑

- 从 `奇特的一生` 入坑的人很多
- 但是, 真正根据自己的情况, 慢慢找到工具组合,并能对数据进行合理分析的太少
- 更加少的是真正如 `柳比歇夫` 那样将数据又反作用自己生活中的...


## Goal
> 所以, 被怼友们触发, 筹备将这个领域的经验变成一门课程

- 以自身积累数据为引
- 以自怼圈积累代码为药
- 为目标学员服务:
    + 形成高效客观时帐记录习惯
    + 对数据进行针对性统计分析
    + 就分析结果共同解读并建议
    + 相互督促根据结果持续改进

## Process
> 那么, 这个网站应该是集体维护的, 怎么来呢?

当然依托 GitHub 生态了:

- 免费托管, 开源仓库
- [utterances](https://utteranc.es/) 寄生评注
- 定制域名
- 远程触发
- 编译日志复审
- ...

### MkDocs
> 因为是 Pythonic 社区,所以, 首先在 Python 生态中选择

- 其它各种 静态网络引擎, 都是针对blog 系统的
- 最大的问题就是, 引擎依赖 每篇文章 .md 的头部 额外 meta 信息
    + 这对基于 md 的写作很是个困惑
- 只有 MkDocs 是针对开发文档网站设计的
    + 每个具体页面发布路径都是自动匹配自然目录的
    + 而且每个 md 都是干净的, 不用声明一堆头部 meta 的
- 所以, 就是她了...

### Deploy
> 必须能自动化触发部署呢...

所以,当前:


    local ++ _trigger/deploy.md
        +-> 101camp/tm
        |       .
        |       .
        |       |
        | [ztop@aliyun]
        |   +- crontab (15')
        |       +- tm
        |           +- inv pub tm
        |               +- _trigger/deploy.md
     branch                <if exsit>
    gh-pages                    +- mkdoc build
        |                         / |
        +--- <<- ----- tm_ghp <<-+  | (deploy logging)
          + <<- -  <<-+
          |    dlog_tm101camp
        branch 
      dlog_tm101camp
          |
          +-> 101camp/comments


在有关主机中部署为:

- 目录 tm 克隆自 [101camp/tm](https://github.com/101camp/tm) 
- 目录 tm_ghp 切换自[101camp/tm at gh\-pages](https://github.com/101camp/tm/tree/gh-pages) 
    + 并将 tm_ghp 用 `ln -s` 软链接形式, 链接到 `tm/site`
    + 作为 MkDocs 编译目标目录
- 目录 dlog_tm101camp 使用 orphan 分支克隆法, 单独 clone [101camp/comments at dlog\_tm101camp](https://github.com/101camp/comments/tree/dlog_tm101camp) 
    + 作为编译事务日志容器
- [cron4trig2tm\.sh](https://github.com/101camp/tm/blob/master/cron4trig2tm.sh) 作为主机定期任务
    + 每 15 分钟自动运行一行
    + 调用 `inv pub tm` 指令
    + 这是由 [tasks\.py](https://github.com/101camp/tm/blob/master/tasks.py) 提供的
    + 将自动化完成一系列行为, 主要包含:
        * 同步所有仓库
        * 检验是否有 `_trigger/deploy.md` 触发文件
        * 如果有,则使用 `mkdoc build` 指令编译最新版本网站
        * 然后, 进入 `tm_ghp` 目录将生成的静态网站 push 给 github 完成最后的发布
- 同时, [cron4trig2tm\.sh](https://github.com/101camp/tm/blob/master/cron4trig2tm.sh) 收集自动发布过程中的所有系统输出
    + 写入 `dlog_tm101camp` 对应目录的 .log 文件
    + 并 push 给 github
    + 这样, 即便我们不在电脑前, 无法远程登陆主机
    + 也可以观察到对应发布行为过程是否有问题
    
    
#### 为什么不使用 `mkdocs gh-deploy` 进行部署？

讨论来自于 200212 @Slack

@zoejane 
> 我想请教的是，如果日常是用自己的电脑，mkdocs gh-deploy 操作简洁，运行后无需等待，实时生效，不是更方便吗？我日常使用 mkdocs gh-deploy推送网页，会 对整个自动化部署、或者网站运行有什么不好的影响吗？

@ZoomQuiet 
> 你看一下 invoke 脚本就知道了….  
> 日常使用, 除非没有其它额外追加操作,  
> 是兼容的, 如果有特殊行为就不行了….  
> 比如, 你可能没发现, gh-deploy 仅仅进行了 build 操作,  
> 但是, inv pub 中包含了大量的自动化 文件感知和索引生成操作,  
> 这是 mkdoc 不包含的行为  

@zoejane 
> 明白了，比如有的auto index injected by xxx的内容，是需要对应脚本去实现的，
> 如果很多内容可以自动抓取，后续就不用手工更新了

@ZoomQuiet 
> 因为 mkdoc build 只干了两件事儿:  
> 0: 尽可能将所有 doc 中的 md 编译为 html  
> 1: 根据 .yaml 配置文件将指定的关键页面组成网站  
> 但是, 我们的网站已经进一步定制化了:  
> 配置只规划了栏目结构,但是, 所有更新带来的变化要求自动化完成增补:  
> 0: 首页的最近 7篇文章索引  
> 1: 每个栏目首页的所有文章索引  
> 2: …  
> 所以, 你懂的…  

### Usage
> 而所有联合运营成员, 想更新 tm.101.camp 网站内容就非常简洁了

- 克隆 [101camp/tm](https://github.com/101camp/tm) 
- 对 `docs/` 中的 .md 文件进行自然的编写/创建/删除/...
- 然后, `touch _trigger/deploy.md`, 创建一个空白文件(deploy.md)到约定目录中
- 提交变更
- 一般等待10分钟左右, 就将完成自动部署.


## Debug:
> 然而, 想真正整个流程可以在本地跑起来, 还是有点儿配置的...

### env. 
> 部署和主机端一致的目录树

从一个合适的真正的空白目录开始:

    path/2/全新空白目录:
        +- tm_ghp/ ~ 发布分支, 配合 github-pages 系统
        |       clone 自 github.com:101camp/tm    
        |           并切换到 gh-pages 分支
        |       
        +- tm/ ~ 主分支, 撰写
        |       clone 自 github.com:101camp/tm    
        |               然后, ln -s ../tm_ghp/ site
        |       
        `- dlog_tm101camp/
                用 orphan 分支独立 clone 的方法复制 commits 仓库的专用分支
                $ mkdir dlog_tm101camp
                $ cd dlog_tm101camp/
                $ git init .
                $ git remote add -t dlog_tm101camp \
                        f origin  git@github.com:101camp/comments.git
                $ git co dlog_tm101camp
                $ git br -a
                * dlog_tm101camp
                  remotes/origin/dlog_tm101camp


然后, 将这个包含三个功能仓库的目录, 追加到系统环境中

$ echo 'export CAMP_TM="path/2/全新空白目录"' >> ~/.bash_profile

更新系统变量:

$ source ~/.bash_profile

应该可以检验到设置成功:

    $ env | grep CAMP_TM
    CAMP_TM="path/2/全新空白目录

> 返回的目录就是三个功能仓库的根目录

### inv
先批量完成依赖模块的安装:

    $ pip install -r requirements.txt

然后, 进入 tm 目录就可以使用专用脚本来完成自动化批量发布处置了:

> 检验所有指令:

    $  inv -l
    Available tasks:

      bu       usgae MkDocs build AIM site
      ccname
      pub      $ inv pub blog <- auto deploy new site version base multi-repo.
      ver      echo crt. verions

> 自动发布:

    $  inv pub tm
    /opt/data/Sites/101.camp/_running/TM

         crt. PATH ===
    /opt/data/Sites/101.camp/_running/TM/tm
    ...

将尝试进行一系列自动化发布:

- 同步所有仓库
- 检验是否有发布触发文件
- 如果有:
    + 更新所有目录索引
    + 更新首页最新索引
    + 构建网站
    + 删除触发文件
    + 发布撰写仓库
    + 同步 CNAME
    + 发布发布仓库
    + ...
- 如果冇:
    + 结束


## refer.

- [奇特的一生 (柳比歇夫坚持56年的“时间统计法”)](https://book.douban.com/subject/1115353/)
- [aTL2 私人故事 ~ DebugUself with DAMA ;-)](https://du.101.camp/2018-10/atl2tt-story/)
- ...




## logging

- 200303 ZQ 增补 inv pub tm 使用说明
- 202012 ZQ 增补说明
- 202010 ZQ init.

