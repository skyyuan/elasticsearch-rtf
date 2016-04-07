# Install Guide

## 安装配置es

### 安装rpm
```sh
rpm -iUvh https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.5.noarch.rpm
```

> NOT starting on installation, please execute the following statements to configure elasticsearch service to start automatically using systemd

```
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
```

> You can start elasticsearch service by executing

```
sudo systemctl start elasticsearch.service
```

### 各项文件路径：
* systemd service: `/usr/lib/systemd/system/elasticsearch.service`
* config file: `/etc/elasticsearch/elasticsearch.yml`
* home: `/usr/share/elasticsearch`
* environment file: `/etc/sysconfig/elasticsearch`

#### 配置好的文件

参考`config/elasticsearch.yml`

## 安装配置插件

### 安装插件

执行脚本：
```bash -i -c "$(curl -s https://raw.githubusercontent.com/LYY/elasticsearch-rtf/master/installtions/ins_plugins.sh)"```

### 配置es文件权限

并且在`/data`目录下，创建es的工作目录。

执行脚本：
```bash -i -c "$(curl -s https://raw.githubusercontent.com/LYY/elasticsearch-rtf/master/installtions/configes.sh)"```

### 各插件配置

#### 配置大杂烩

包括pinyin分词、ansj分词、默认分词、ik分词的配置

```
index:
  analysis:
    tokenizer:
      my_pinyin:
        type: pinyin
        first_letter: prefix
        padding_char: ''
      pinyin_first_letter:
        type: pinyin
        first_letter: only
      semicolon_spliter:
        type: pattern
        pattern: ";"
      pct_spliter:
        type: pattern
        pattern: "[%]+"
      ngram_1_to_2:
        type: nGram
        min_gram: 1
        max_gram: 2
      ngram_1_to_3:
        type: nGram
        min_gram: 1
        max_gram: 3
      comma_sep:
        type: pattern
        pattern: '[,，]'
    filter:
      ngram_min_3:
        max_gram: 10
        min_gram: 3
        type: nGram
      ngram_min_2:
        max_gram: 10
        min_gram: 2
        type: nGram
      ngram_min_1:
        max_gram: 10
        min_gram: 1
        type: nGram
      min2_length:
        min: 2
        max: 4
        type: length
      min3_length:
        min: 3
        max: 4
        type: length
      pinyin_first_letter:
        type: pinyin
        first_letter: only
      nGram_2_to_20:
        type: edgeNGram
        min_gram: 2
        max_gram: 20
      prefix_pinyin:
        type: pinyin
        first_letter: only
        padding_char: ''
    analyzer:
      lowercase_keyword:
        type: custom
        filter:
        - lowercase
        tokenizer: standard
      lowercase_keyword_ngram_min_size1:
        type: custom
        filter:
        - lowercase
        - stop
        - trim
        - unique
        tokenizer: nGram
      lowercase_keyword_ngram_min_size2:
        type: custom
        filter:
        - lowercase
        - min2_length
        - stop
        - trim
        - unique
        tokenizer: nGram
      lowercase_keyword_ngram_min_size3:
        type: custom
        filter:
        - lowercase
        - min3_length
        - stop
        - trim
        - unique
        tokenizer: ngram_1_to_3
      lowercase_keyword_ngram:
        type: custom
        filter:
        - lowercase
        - stop
        - trim
        - unique
        tokenizer: ngram_1_to_3
      lowercase_keyword_without_standard:
        type: custom
        filter:
        - lowercase
        tokenizer: keyword
      lowercase_whitespace:
        type: custom
        filter:
        - lowercase
        tokenizer: whitespace
      comma_spliter:
        type: pattern
        pattern: "[,|\\s]+"
      pct_spliter:
        type: pattern
        pattern: "[%]+"
      custom_snowball_analyzer:
        type: snowball
        language: English
      simple_english_analyzer:
        type: custom
        tokenizer: whitespace
        filter:
        - standard
        - lowercase
        - snowball
      edge_ngram:
        type: custom
        tokenizer: edgeNGram
        filter:
        - lowercase
      pinyin_ngram_analyzer:
        type: custom
        tokenizer: my_pinyin
        filter:
        - lowercase
        - nGram
        - trim
        - unique
      pinyin_first_letter_analyzer:
        type: custom
        tokenizer: pinyin_first_letter
        filter:
        - standard
        - lowercase
      pinyin_first_letter_keyword_analyzer:
        alias:
        - pinyin_first_letter_analyzer_keyword
        type: custom
        tokenizer: keyword
        filter:
        - pinyin_first_letter
        - lowercase
      path_analyzer: #used for tokenize :/something/something/else
        type: custom
        tokenizer: path_hierarchy
      index_ansj:
        type: ansj_index
      query_ansj:
        type: ansj_query
      ik:
        alias: [ik_analyzer]
        type: org.elasticsearch.index.analysis.IkAnalyzerProvider
      ik_max_word:
        type: ik
        use_smart: false
      ik_smart:
        type: ik
        use_smart: true
      full_pinyin:
        type: custom
        tokenizer: ik
        filter:
          - pinyin
          - lowercase
          - trim
          - unique
      prefix_pinyin:
        type: custom
        tokenizer: ik
        filter:
          - prefix_pinyin
          - lowercase
          - trim
          - unique
      full_pinyin_ngram:
        type: custom
        tokenizer: ik
        filter:
          - pinyin
          - lowercase
          - nGram_2_to_20
          - trim
          - unique
      prefix_pinyin_ngram:
        type: custom
        tokenizer: ik
        filter:
          - prefix_pinyin
          - lowercase
          - nGram_2_to_20
          - trim
          - unique
      comma_sep:
        type: custom
        tokenizer: comma_sep
        filter:
          - lowercase
          - trim

index.analysis.analyzer.default.type: ansj_index
```

#### ansj

> redis使用的jar用默认脚本启动会有权限问题，此问题目前只能加./elasticsearch -Des.security.manager.enabled=false参数来解决

修改`/etc/elasticsearch/elasticsearch.yml`，增加ansj配置：

```
## ansj配置
ansj:
 dic_path: "ansj/dic/user/" ##用户词典位置
 ambiguity_path: "ansj/dic/ambiguity.dic" ##歧义词典
 enable_name_recognition: true ##人名识别
 enable_num_recognition: true ##数字识别
 enable_quantifier_recognition: false ##量词识别
 enabled_stop_filter: true ##是否基于词典过滤
 stop_path: "ansj/dic/stopLibrary.dic" ##停止过滤词典
## redis 不是必需的
 redis:
  pool:
   maxactive: 20
   maxidle: 10
   maxwait: 100
   testonborrow: true
  ip: 10.0.85.51:6379
  channel: ansj_term ## publish时的channel名称
  write:
    dic: "ext.dic" ##如果有使用redis的pubsub方式更新词典，默认使用 这个目录是相对于dic_path
```

