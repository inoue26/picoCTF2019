# pico CTF write up
* * *
## General Skills
### 1. 2Warm - Points: 50 - (Solves: 15005)
  (problem)
    Can you convert the number 42 (base 10) to binary (base 2)?

  (answer)
    10進数から2進数への変換の問題。
    $42 = 1*2^5+1*2^3+1*2^1$
    なので"101010"

### 2. Lets Warm Up - Points: 50 - (Solves: 21614)
  (problem)
    If I told you a word started with 0x70 in hexadecimal, what would it start with in ASCII?

  (answer)
    16進数表示をASCIIに変換する問題。ASCIIコード表をみればよい
    [ASCII変換サイト](http://web-apps.nbookmark.com/ascii-converter/]) , [ASCIIコード表](http://www3.nit.ac.jp/~tamura/ex2/ascii.html)
    これらによると16進数表示の0x70(112)は"p"

### 3. Warmed Up - Points: 50 - (Solves: 16179)
(problem)
    What is 0x3D (base 16) in decimal (base 10).　　

(answer)
    16進数から10進数にする問題。
    $$3*16 + 13(D)*1 = 61 $$
### 4. Bases - Points: 100 - (Solves: 9187)

(problem)
    What does this bDNhcm5fdGgzX3IwcDM1 mean? I think it has something to do with bases.

(answer)
    文字列の基数を予想する。16進数表示ではないけど数字とアルファベットしかないのでbase58の可能性もあるがとりあえずbase64で様子見。
    pythonにbase64という便利なライブラリがあるのでimportして以下のように書けば64進数の文字列がdecodeされる。
~~~python
    import base64
    encoded_string = 'bDNhcm5fdGgzX3IwcDM1'
    decoded_string = base64.standard_b64decode(encoded_string)
    print(decoded_string)
~~~
decode結果は'l3arn_th3_r0p35'

  ### 5. First Grep - Points: 100 - (Solves: 9470)

  (problem)
      Can you find the flag in file? This would be really tedious to look through manually, something tells me there is a better way. You can also find the file in /problems/first-grep_5_452e1c1630eb14b6753e9a155c3ae588 on the shell server.

  (answer)
      shellをひらいて指定されたディレクトリに移動。flagの形式はpico{(flag)}なのでfileをgrepに渡してpicoを検索させる。具体的には次のコマンドを打てばでてくる。
  ~~~shell
      grep pico file
  ~~~
  ### 6. Resources - Points: 100 - (Solves: 9989)

  (problem)
    We put together a bunch of resources to help you out on our website! If you go over there, you might even find a flag! https://picoctf.com/resources (link)

  (answer)
    基本的な知識がかいてあるので読むだけ
  ### 7. strings it - Points: 100 - (Solves: 8284)

  (problem)
      Can you find the flag in file without running it? You can also find the file in /problems/strings-it_4_e276260a1b64a734b4178a280d25b754 on the shell server.

  (answer)
      binaryファイルのなかから文字列だけを取り出すコマンド"strings"をもちいる
  ~~~shell
      strings string | grep pico
  ~~~
  でflagが獲得できる。
  ### 8. what's a net cat? - Points: 100 - (Solves: 8088)

  (problem)
      Using netcat (nc) is going to be pretty important. Can you connect to 2019shell1.picoctf.com at port 21865 to get the flag?

  (answer)
      TCP・UDPによるネットワーク通信を行うnetcat(nc)を用いる問題。詳細は[ncコマンド](http://www.ksknet.net/linux/nc_netcat.html) [ncコマンドの使い方](https://qiita.com/hana_shin/items/97e6c03ac5e5ed67ce38)を参照。
      今回は名前解決をしてアドレスを指定して、開放してあるポートに接続すればよい。
  ~~~shell
       nc 2019shell1.picoctf.com 21865
  ~~~
  でflagが獲得できる。
  ### 9. Based - Points: 200 - (Solves: 5899)

  (problem)
      To get truly 1337, you must understand different data encodings, such as hexadecimal or binary. Can you get the flag from this program to prove you are on the way to becoming 1337? Connect with nc 2019shell1.picoctf.com 28758.

  (answer)
      指定したポートにアクセスすると、以下のASCIIへのdecodingを時間制限付きでやるので変換する関数を予め書いて臨む。コードは最適ではないですが参考までに。（import base16）

  1. 2進数からASCII
      8bitごとに空白で区切られているので、さらにそれを16進数にするために4bitずつに小分けする。4bitごとに16進数表記に直していきASCIIコード変換する。
  ~~~python
      def binary2ascii(binary):
        binary_list = binary.split(' ')
        hex_string = ''
        dec_string = ''
        for bite in binary_list:
            dec0 = int(bite[0:4], 2)
            dec1 = int(bite[4:8], 2)
            dec_string += str(dec0)
            dec_string += str(dec1)
            hex0 = format(dec0, 'x')
            hex1 = format(dec1, 'x')
            hex_string += hex0.upper()
            hex_string += hex1.upper()
        encoded_string = hex_string
        decoded_string = base64.b16decode(encoded_string)
        return decoded_string
  ~~~
  2. 8進数からASCII
      3桁ずつ区切って8bitのbinary表記にする。その後上の関数に食わせる。
  ~~~python
      def oct2binary(oct_strings):
        oct_list = oct_strings.split(' ')
        bin_strings = ''
        for oct_ in oct_list:
            dec = int(str(oct_), 8)
            bin_ = format(int(dec), 'b').zfill(8)
            bin_strings += bin_
            bin_strings += ' '
        # print('bin_strings',bin_strings)
        return bin_strings
  ~~~
  3. 16進数からASCII
      base16におまかせする。
  ~~~python
      def hex2ascii(hex_string):
        decoded_string = base64.b16decode(hex_string.upper())
        return decoded_string
  ~~~

### 10. First Grep: Part II - Points: 200 - (Solves: 6402)

  (problem)
  Can you find the flag in /problems/first-grep--part-ii_0_b68f6a4e9cb3a7aad4090dea9dd80ce1/files on the shell server? Remember to use grep.

  (answer)
  複数ディレクトリにまたがる全ファイルに対してgrepをかければよい。一度に全ファイルを網羅してgrepするためにfindコマンドの-execオプションを用いる。詳細は[findコマンド](https://eng-entrance.com/linux-command-find)
  ~~~shell
    find * -type f -exec cat {} \; | grep pico
  ~~~
でflagが獲得できる。

### 11. plumbing - Points: 200 - (Solves: 6004)

(problem)
    Sometimes you need to handle process data outside of a file. Can you find a way to keep the output from this program and search for the flag? Connect to 2019shell1.picoctf.com 57911.

(answer)
    指示されたポートに接続すると長々と文字列が出力されるので、パイプラインでgrepをかければよい。
  ~~~shell
    nc 2019shell1.picoctf.com 57911 | grep pico
  ~~~
### 12. whats-the-difference - Points: 200 - (Solves: 2693)

(problem)
    Can you spot the difference? kitters cattos. They are also available at /problems/whats-the-difference_0_00862749a2aeb45993f36cc9cf98a47a on the shell server

(answer)
    pythonとかで処理したらいいかとおもいつつも、せっかくなのでコマンドだけでやってみました。image(.jpg)をASCII(.txt)にdumpして（指定されたディレクトリ上でpermission deniedされたのでhomeディレクトリで実行）、diffコマンドで2つのファイルの差分をとって可視化する。
  ~~~shell
    # imageをasciiでdump & 1バイトずつ改行
    hexdump -e '1/1 "%_p"' -e '"\n"' /problems/whats-the-difference_0_00862749a2aeb45993f36cc9cf98a47a/kitters.jpg > kitters.txt
    hexdump -e '1/1 "%_p"' -e '"\n"' /problems/whats-the-difference_0_00862749a2aeb45993f36cc9cf98a47a/cattos.jpg > cattos.txt
    # 差分の可視化
    diff -y --suppress-common-lines kitters.txt cattos.txt > diff.txt
    # 3列目だけ取り出す
    cat diff.txt | awk '{ print $3 }'
  ~~~
まとめると以上のコマンドになり、flagが獲得できる。
### 13. where-is-the-file - Points: 200 - (Solves: 5394)　　

(problem)
    I've used a super secret mind trick to hide this file. Maybe something lies in /problems/where-is-the-file_3_19c1a7766ac2747c446eb9666a9b4fb4.

(answer)
    指示されたディレクトリにいってlsしても何も出てこないのでls -aを実行するとcant_see_meというファイルがでてくるのでcatで中身をみるとflagがそのままかいてある。
### 14. flag_shop - Points: 300 - (Solves: 2049)

(problem)
    There's a flag shop selling stuff, can you buy a flag? Source. Connect with nc 2019shell1.picoctf.com 60851.

(answer)
    所持金（account_balance）を増やさないとflagは手に入らないらしいので増やす方法を考える。
    source（以下に一部抜粋）をみると、
  ~~~c
    if(number_flags > 0){
        int total_cost = 0;
        total_cost = 900*number_flags;
        printf("\nThe final cost is: %d\n", total_cost);
        if(total_cost <= account_balance){
            account_balance = account_balance - total_cost;
            printf("\nYour current balance after transaction: %d\n\n", account_balance);
        }
        else{
            printf("Not enough funds to complete purchase\n");
        }


    }
  ~~~
負の個数は受け付けないし、普通に購入していても減るだけだけど、total_costをoverflowさせれば1bit目が1になり符号が反転するはずなので、決算時に引き算になっているところが足し算に変わる。
    そこでc言語がintは32bitの精度であることを考慮する。
    符号が正のintは、最初のbitが必ず0なので
    $2^{32-1}-1$
    が正の取りうる最大の数でこれを超えると
    $-2^{32-1}$
    から0に近づいていく。 なので
    $(2^{32-1}-1)/900+1$
    購入すれば億万長者になれるはずである。
    2386093個購入すると-2147482600円請求されたので億万長者になりました。それで高い方のflagを買えばflag獲得できる。
