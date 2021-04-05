{
  action-cable-testing = {
    dependencies = ["actioncable"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nj4y9058mm6rvs5wl613hnflqi3727x3y7h0wsh6bbvakm9gqib";
      type = "gem";
    };
    version = "0.6.1";
  };
  actioncable = {
    dependencies = ["actionpack" "nio4r" "websocket-driver"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rlx5597621jmdzpf8mhfm52d0fcz1izdj94k58l4sln4gw0x73j";
      type = "gem";
    };
    version = "5.2.4.5";
  };
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "mail" "rails-dom-testing"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19y5y2dypqakk39smcmyslic8wnffzc0670d2zjadsrgsg850gyp";
      type = "gem";
    };
    version = "5.2.4.5";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dh83klnrhfi94s066ahfl2bxaqxqc0sqga71bvcgn8xmcl56bhq";
      type = "gem";
    };
    version = "5.2.4.5";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kxf9gd52hh33z6015gsfsnyavly29f15lbsljlai68r7qc2j89c";
      type = "gem";
    };
    version = "5.2.4.5";
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mb4s49vbrxyg3pba76z3llbzclm8d4zcjhalf4yrfq5y357kkya";
      type = "gem";
    };
    version = "5.2.4.5";
  };
  activemodel = {
    dependencies = ["activesupport"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qc4bjxnkjrlqpz2k7hllqk30ydad5m2q7pbqzdr0hxzycavxz7m";
      type = "gem";
    };
    version = "5.2.4.5";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "arel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1smg691az7r2bsydfj2d46mr2d5sm0lq3ydwvfv6hl5c3y1y5jfg";
      type = "gem";
    };
    version = "5.2.4.5";
  };
  activestorage = {
    dependencies = ["actionpack" "activerecord" "marcel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12i3an3vxg0fqjvr4mi0b3nnsb8jpcphkmz1717nb7lsy3wm4081";
      type = "gem";
    };
    version = "5.2.4.5";
  };
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo"];
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fp4gr3g25qgl01y3pd88wfh4pjc5zj3bz4v7rkxxwaxdjg7a9cc";
      type = "gem";
    };
    version = "5.2.4.5";
  };
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fvchp2rhp2rmigx7qglf69xvjqvzq7x0g49naliw29r2bz656sy";
      type = "gem";
    };
    version = "2.7.0";
  };
  aes_key_wrap = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19bn0y70qm6mfj4y1m0j3s8ggh6dvxwrwrj5vfamhdrpddsz8ddr";
      type = "gem";
    };
    version = "1.1.0";
  };
  arel = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jk7wlmkr61f6g36w9s2sn46nmdg6wn2jfssrhbhirv5x9n95nk0";
      type = "gem";
    };
    version = "9.0.0";
  };
  ast = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04nc8x27hlzlrr5c2gn7mar4vdr0apw5xg22wp6m8dx3wqr04a0y";
      type = "gem";
    };
    version = "2.4.2";
  };
  attr_required = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g22axmi2rhhy7w8c3x6gppsawxqavbrnxpnmphh22fk7cwi0kh2";
      type = "gem";
    };
    version = "1.0.1";
  };
  autoprefixer-rails = {
    dependencies = ["execjs"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05z02ylv8rbcc3k6zlngizixc9csy779cqmlaa8hn7kylxizk3gy";
      type = "gem";
    };
    version = "10.2.4.0";
  };
  aws-eventstream = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jfki5ikfr8ln5cdgv4iv1643kax0bjpp29jh78chzy713274jh3";
      type = "gem";
    };
    version = "1.1.1";
  };
  aws-partitions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13hy3xhff1cqlzv5hi3lz7vb11wh10m6221hq471d8m94chmmkjs";
      type = "gem";
    };
    version = "1.435.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1774xyfqf307qvh5npvf01948ayrviaadq576r4jxin6xvlg8j9z";
      type = "gem";
    };
    version = "3.113.0";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01pd0f4srsa65zl4zq4014p9j5yrr2yy9h9ab17g3w9d0qqm2vsh";
      type = "gem";
    };
    version = "1.43.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mzcf0p81mkimks7l1mqzkxwnjbsp5qsh07vvcb9i2199hf8yg63";
      type = "gem";
    };
    version = "1.88.2";
  };
  aws-sigv4 = {
    dependencies = ["aws-eventstream"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d9zhmi3mpfzkkpg7yw7s9r1dwk157kh9875j3c7gh6cy95lmmaw";
      type = "gem";
    };
    version = "1.2.3";
  };
  bcrypt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02r1c3isfchs5fxivbq99gc3aq4vfyn8snhcy707dal1p8qz12qb";
      type = "gem";
    };
    version = "3.1.16";
  };
  bigbluebutton-api-ruby = {
    dependencies = ["childprocess" "ffi" "json" "nokogiri" "rack" "rubyzip" "xml-simple"];
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "91dc495324a6b7e162773227ec3650f8a5b39c50";
      sha256 = "1ws8hrsyhnpaxrf4l5n6nawpwhwyz8bxzf0g8wdwcq3a55ad395c";
      type = "git";
      url = "https://github.com/mconf/bigbluebutton-api-ruby.git";
    };
    version = "1.7.0";
  };
  bindata = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bmlqjb5h1ry6wm2d903d6yxibpqzzxwqczvlicsqv0vilaca5ic";
      type = "gem";
    };
    version = "2.4.8";
  };
  bindex = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zmirr3m02p52bzq4xgksq4pn8j641rx5d4czk68pv9rqnfwq7kv";
      type = "gem";
    };
    version = "0.8.1";
  };
  bn-ldap-authentication = {
    dependencies = ["net-ldap"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c1n6xzljmzy33zfbzv6gn6y4qj7342b0ckdznymcm8l6671xnml";
      type = "gem";
    };
    version = "0.1.4";
  };
  bootsnap = {
    dependencies = ["msgpack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j09ins6z8drcjlj63wqa5ry0cqb7vsgjkl9f2jc59skp5v989px";
      type = "gem";
    };
    version = "1.7.3";
  };
  bootstrap = {
    dependencies = ["autoprefixer-rails" "popper_js" "sassc-rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ha79izzizcrfisvhh3h7plm898farrw4v703cfqwb6wih03iv7h";
      type = "gem";
    };
    version = "4.3.1";
  };
  builder = {
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "045wzckxpwcqzrjr353cxnyaxgf0qg22jh00dcx7z38cys5g1jlr";
      type = "gem";
    };
    version = "3.2.4";
  };
  byebug = {
    groups = ["development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nx3yjf4xzdgb8jkmk2344081gqr22pgjqnmjg2q64mj5d6r9194";
      type = "gem";
    };
    version = "11.1.3";
  };
  cancancan = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08qyj4cljwwwan1ssvv1nzfj7sbsy8lrn7f42mkfd6j75gskg2kb";
      type = "gem";
    };
    version = "2.3.0";
  };
  childprocess = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08hd3d2lfi19cns4d6wkq51scasn17l83fgbzbjjk3dqccz4rg3j";
      type = "gem";
    };
    version = "4.0.0";
  };
  concurrent-ruby = {
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mr23wq0szj52xnj0zcn1k0c7j4v79wlwbijkpfcscqww3l6jlg3";
      type = "gem";
    };
    version = "1.1.8";
  };
  coveralls = {
    dependencies = ["json" "simplecov" "term-ansicolor" "thor" "tins"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mv4fn5lfxhy7bc2f1lpnc5yp9mvv97az77j4r7jgrxcqwn8fqxc";
      type = "gem";
    };
    version = "0.8.23";
  };
  crack = {
    dependencies = ["rexml"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cr1kfpw3vkhysvkk3wg7c54m75kd68mbm9rs5azdjdq57xid13r";
      type = "gem";
    };
    version = "0.4.5";
  };
  crass = {
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pfl5c0pyqaparxaqxi6s4gfl21bdldwiawrc0aknyvflli60lfw";
      type = "gem";
    };
    version = "1.0.6";
  };
  declarative = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yczgnqrbls7shrg63y88g7wand2yp9h6sf56c9bdcksn5nds8c0";
      type = "gem";
    };
    version = "0.0.20";
  };
  declarative-option = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g4ibxq566f1frnhdymzi9hxxcm4g2gw4n21mpjk2mhwym4q6l0p";
      type = "gem";
    };
    version = "0.1.0";
  };
  diff-lcs = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m925b8xc6kbpnif9dldna24q1szg4mk0fvszrki837pfn46afmz";
      type = "gem";
    };
    version = "1.4.4";
  };
  digest-crc = {
    dependencies = ["rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "118d5p02kdw6a5pi8af12dxma7q3b77zz5q5xjjf5kgp8qh1930a";
      type = "gem";
    };
    version = "0.6.3";
  };
  docile = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bpdrsdqwv80qqc3f4xxzpii13lx9mlx3zay4bnmmscrx8c0p63z";
      type = "gem";
    };
    version = "1.3.5";
  };
  dotenv = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iym172c5337sm1x2ykc2i3f961vj3wdclbyg1x6sxs3irgfsl94";
      type = "gem";
    };
    version = "2.7.6";
  };
  dotenv-rails = {
    dependencies = ["dotenv" "railties"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1my2jdmgmpf32rfxffkb9cyxh7ayis4q5ygpwjqj4vpp25y3a70c";
      type = "gem";
    };
    version = "2.7.6";
  };
  erubi = {
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09l8lz3j00m898li0yfsnb6ihc63rdvhw3k5xczna5zrjk104f2l";
      type = "gem";
    };
    version = "1.10.0";
  };
  execjs = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yz55sf2nd3l666ms6xr18sm2aggcvmb8qr3v53lr4rir32y1yp1";
      type = "gem";
    };
    version = "2.7.0";
  };
  factory_bot = {
    dependencies = ["activesupport"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11ij9s4hasy963qjqbrrf0m8lm9m9pxkh2vf4wrnafa6gw6r9qk8";
      type = "gem";
    };
    version = "6.1.0";
  };
  factory_bot_rails = {
    dependencies = ["factory_bot" "railties"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hfxkq6rarg0b8xfzqg200xyj176sn1xplqqqcrz5drhkqp30m14";
      type = "gem";
    };
    version = "6.1.0";
  };
  faker = {
    dependencies = ["i18n"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z3d4y6xg8prn3zdjw1qpqrnziq1d3zigqil4sxjj0pbr46gc1d6";
      type = "gem";
    };
    version = "2.17.0";
  };
  faraday = {
    dependencies = ["faraday-net_http" "multipart-post" "ruby2_keywords"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hmssd8pj4n7yq4kz834ylkla8ryyvhaap6q9nzymp93m1xq21kz";
      type = "gem";
    };
    version = "1.3.0";
  };
  faraday-net_http = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fi8sda5hc54v1w3mqfl5yz09nhx35kglyx72w7b8xxvdr0cwi9j";
      type = "gem";
    };
    version = "1.0.1";
  };
  ffi = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nq1fb3vbfylccwba64zblxy96qznxbys5900wd7gm9bpplmf432";
      type = "gem";
    };
    version = "1.15.0";
  };
  font-awesome-sass = {
    dependencies = ["sassc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h9wzdmjpzijmx084sjzjgv4ixmyah76jbv53msf7wyxvif42qrq";
      type = "gem";
    };
    version = "5.9.0";
  };
  globalid = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zkxndvck72bfw235bd9nl2ii0lvs5z88q14706cmn702ww2mxv1";
      type = "gem";
    };
    version = "0.4.2";
  };
  google-apis-core = {
    dependencies = ["addressable" "googleauth" "httpclient" "mini_mime" "representable" "retriable" "rexml" "signet" "webrick"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jx4jiyfjxd8pxlpi94f07cb5yvljb5rv7i8xzjq2xrrlvdf212a";
      type = "gem";
    };
    version = "0.3.0";
  };
  google-apis-iamcredentials_v1 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bgj08crw5c0yf08pmgh77jhdm0wbbnj0pms7c48mkxcxcg5zjw4";
      type = "gem";
    };
    version = "0.2.0";
  };
  google-apis-storage_v1 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q6d5grhrkyfxmzlv0y39i6wzq5ayq1lkp33vfcg9pm8jyzcz7b2";
      type = "gem";
    };
    version = "0.3.0";
  };
  google-cloud-core = {
    dependencies = ["google-cloud-env" "google-cloud-errors"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0amp8vd16pzbdrfbp7k0k38rqxpwd88bkyp35l3x719hbb6l85za";
      type = "gem";
    };
    version = "1.6.0";
  };
  google-cloud-env = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ajc3w4wqg46ywcbmb5fz1q6gfm6g7874s9h31i1r038kz2bzfag";
      type = "gem";
    };
    version = "1.5.0";
  };
  google-cloud-errors = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q3h996b6vl2ryfbm9jwczjcbnwhkpqs6hingxp22rhzk7qxi9z0";
      type = "gem";
    };
    version = "1.1.0";
  };
  google-cloud-storage = {
    dependencies = ["addressable" "digest-crc" "google-apis-iamcredentials_v1" "google-apis-storage_v1" "google-cloud-core" "googleauth" "mini_mime"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17axi5gmy0g04801v11lww5mvqzffqdc3w6k1j7f95v90hy4yn6m";
      type = "gem";
    };
    version = "1.30.0";
  };
  googleauth = {
    dependencies = ["faraday" "jwt" "memoist" "multi_json" "os" "signet"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10bmh6i9qh7ybw8q6amgalwmxxkcdwnjqyc3674c29hlz0881yw9";
      type = "gem";
    };
    version = "0.16.0";
  };
  hashdiff = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nynpl0xbj0nphqx1qlmyggq58ms1phf5i03hk64wcc0a17x1m1c";
      type = "gem";
    };
    version = "1.0.1";
  };
  hashie = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02bsx12ihl78x0vdm37byp78jjw2ff6035y7rrmbd90qxjwxr43q";
      type = "gem";
    };
    version = "4.1.0";
  };
  hiredis = {
    groups = ["production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04jj8k7lxqxw24sp0jiravigdkgsyrpprxpxm71ba93x1wr2w1bz";
      type = "gem";
    };
    version = "0.6.3";
  };
  http_accept_language = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d0nlfz9vm4jr1l6q0chx4rp2hrnrfbx3gadc1dz930lbbaz0hq0";
      type = "gem";
    };
    version = "2.1.1";
  };
  httpclient = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19mxmvghp7ki3klsxwrlwr431li7hm1lczhhj8z4qihl2acy8l99";
      type = "gem";
    };
    version = "2.8.3";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08p6b13p99j1rrcrw1l3v0kb9mxbsvy6nk31r8h4rnszdgzpga32";
      type = "gem";
    };
    version = "1.8.9";
  };
  i18n-language-mapping = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f7ihvzahd541rxi3da24gz30319f3psivj8md6fjhns47p4kh8a";
      type = "gem";
    };
    version = "0.1.2";
  };
  jbuilder = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vz0vp5lbp1bz2samyn8nk49vyh6zhvcqz35faq4i3kgsd4xlnhp";
      type = "gem";
    };
    version = "2.11.2";
  };
  jmespath = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d4wac0dcd1jf6kc57891glih9w57552zgqswgy74d1xhgnk0ngf";
      type = "gem";
    };
    version = "1.4.0";
  };
  jquery-rails = {
    dependencies = ["rails-dom-testing" "railties" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dkhm8lan1vnyl3ll0ks2q06576pdils8a1dr354vfc1y5dqw15i";
      type = "gem";
    };
    version = "4.4.0";
  };
  jquery-ui-rails = {
    dependencies = ["railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mbwwbbwzp836l7mc21amnaqmf5wbrw5hzls48hscrcgh0vig812";
      type = "gem";
    };
    version = "6.0.1";
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lrirj0gw420kw71bjjlqkqhqbrplla61gbv1jzgsz6bv90qr3ci";
      type = "gem";
    };
    version = "2.5.1";
  };
  json-jwt = {
    dependencies = ["activesupport" "aes_key_wrap" "bindata"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nzbk1mrbf9mnvjpn3bxy8a85rjf94qmfdnvk78mjzk8pa0fvgdr";
      type = "gem";
    };
    version = "1.13.0";
  };
  jwt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14ynyq1q483spj20ffl4xayfqx1a8qr761mqjfxczf8lwlap392n";
      type = "gem";
    };
    version = "2.2.2";
  };
  listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r1mr4x1l7x6gkx9avmrwfwagzqf8h71mklrg9dzr01yh132yx65";
      type = "gem";
    };
    version = "3.5.0";
  };
  local_time = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1965297is1h2wzbaln5yawgzxnrpxf7v7qakmcrryjcvbmbkcdnd";
      type = "gem";
    };
    version = "2.1.0";
  };
  lograge = {
    dependencies = ["actionpack" "activesupport" "railties" "request_store"];
    groups = ["production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vrjm4yqn5l6q5gsl72fmk95fl6j9z1a05gzbrwmsm3gp1a1bgac";
      type = "gem";
    };
    version = "0.11.2";
  };
  loofah = {
    dependencies = ["crass" "nokogiri"];
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bzwvxvilx7w1p3pg028ks38925y9i0xm870lm7s12w7598hiyck";
      type = "gem";
    };
    version = "2.9.0";
  };
  mail = {
    dependencies = ["mini_mime"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00wwz6ys0502dpk8xprwcqfwyf3hmnx6lgxaiq6vj43mkx43sapc";
      type = "gem";
    };
    version = "2.7.1";
  };
  marcel = {
    dependencies = ["mimemagic"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nxbjmcyg8vlw6zwagf17l9y2mwkagmmkg95xybpn4bmf3rfnksx";
      type = "gem";
    };
    version = "0.3.3";
  };
  memoist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i9wpzix3sjhf6d9zw60dm4371iq8kyz7ckh2qapan2vyaim6b55";
      type = "gem";
    };
    version = "0.16.2";
  };
  method_source = {
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pnyh44qycnf9mzi1j6fywd5fkskv3x7nmsqrrws0rjn5dd4ayfp";
      type = "gem";
    };
    version = "1.0.0";
  };
  mimemagic = {
    dependencies = ["nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jm6ya12bbdqkm50xzjmx2w4jclmmm7256fp3vw2q6gcvnh2xf1z";
      type = "gem";
    };
    version = "0.3.8";
  };
  mini_mime = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1axm0rxyx3ss93wbmfkm78a6x03l8y4qy60rhkkiq0aza0vwq3ha";
      type = "gem";
    };
    version = "1.0.2";
  };
  mini_portile2 = {
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hdbpmamx8js53yk3h8cqy12kgv6ca06k0c9n3pxh6b6cjfs19x7";
      type = "gem";
    };
    version = "2.5.0";
  };
  minitest = {
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19z7wkhg59y8abginfrm2wzplz7py3va8fyngiigngqvsws6cwgl";
      type = "gem";
    };
    version = "5.14.4";
  };
  msgpack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06iajjyhx0rvpn4yr3h1hc4w4w3k59bdmfhxnjzzh76wsrdxxrc6";
      type = "gem";
    };
    version = "1.4.2";
  };
  multi_json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pb1g1y3dsiahavspyzkdy39j4q377009f6ix0bh1ag4nqw43l0z";
      type = "gem";
    };
    version = "1.15.0";
  };
  multi_xml = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lmd4f401mvravi1i1yq7b2qjjli0yq7dfc4p1nj5nwajp7r6hyj";
      type = "gem";
    };
    version = "0.6.0";
  };
  multipart-post = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zgw9zlwh2a6i1yvhhc4a84ry1hv824d6g2iw2chs3k5aylpmpfj";
      type = "gem";
    };
    version = "2.1.1";
  };
  net-ldap = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j19yxrz7h3hj7kiiln13c7bz7hvpdqr31bwi88dj64zifr7896n";
      type = "gem";
    };
    version = "0.17.0";
  };
  nio4r = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00fwz0qq7agd2xkdz02i8li236qvwhma3p0jdn5bdvc21b7ydzd5";
      type = "gem";
    };
    version = "2.5.7";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b51df8fwadak075cvi17w0nch6qz1r66564qp29qwfj67j9qp0p";
      type = "gem";
    };
    version = "1.11.2";
  };
  oauth = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m08365nyp0fgw2iyzj8q8qy8zml0c1hw2dd8cp82pp6656ahbh3";
      type = "gem";
    };
    version = "0.5.5";
  };
  oauth2 = {
    dependencies = ["faraday" "jwt" "multi_json" "multi_xml" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q6q2kgpxmygk8kmxqn54zkw8cs57a34zzz5cxpsh1bj3ag06rk3";
      type = "gem";
    };
    version = "1.4.7";
  };
  omniauth = {
    dependencies = ["hashie" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "002vi9gwamkmhf0dsj2im1d47xw2n1jfhnzl18shxf3ampkqfmyz";
      type = "gem";
    };
    version = "1.9.1";
  };
  omniauth-bn-launcher = {
    dependencies = ["omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19nlgzidi83s9nh9a4axlq7brisrk0w0841dn43lq0rzahrghqmw";
      type = "gem";
    };
    version = "0.1.3";
  };
  omniauth-bn-office365 = {
    dependencies = ["omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r4mcf2ph1ya4682s3zm1y7jzs4y4k3qy4r9vx141riai6i5jzq1";
      type = "gem";
    };
    version = "0.1.1";
  };
  omniauth-google-oauth2 = {
    dependencies = ["jwt" "omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05c8pl72zwzzn03h8x3b3sx9sspjxvjsdvxsw1pjz5s57mp7klcj";
      type = "gem";
    };
    version = "0.7.0";
  };
  omniauth-oauth = {
    dependencies = ["oauth" "omniauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yw2vzx633p9wpdkd4jxsih6mw604mj7f6myyfikmj4d95c8d9z7";
      type = "gem";
    };
    version = "1.2.0";
  };
  omniauth-oauth2 = {
    dependencies = ["oauth2" "omniauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kscjf1y0lnggsl4z3w5bwllqshqjlsl5kmcya5haydajdnzvdjr";
      type = "gem";
    };
    version = "1.5.0";
  };
  omniauth-twitter = {
    dependencies = ["omniauth-oauth" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r5j65hkpgzhvvbs90id3nfsjgsad6ymzggbm7zlaxvnrmvnrk65";
      type = "gem";
    };
    version = "1.4.0";
  };
  omniauth_openid_connect = {
    dependencies = ["addressable" "omniauth" "openid_connect"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wxf52yggvwmyg6f9fiykh1sk51xx34i6x6m8f06ia56npslc4aw";
      type = "gem";
    };
    version = "0.3.5";
  };
  openid_connect = {
    dependencies = ["activemodel" "attr_required" "json-jwt" "rack-oauth2" "swd" "tzinfo" "validate_email" "validate_url" "webfinger"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nqhgvq006h6crbp8lffw66ll46zf319c2637g4sybdclglismma";
      type = "gem";
    };
    version = "1.2.0";
  };
  os = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12fli64wz5j9868gpzv5wqsingk1jk457qyqksv9ksmq9b0zpc9x";
      type = "gem";
    };
    version = "1.1.1";
  };
  pagy = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g55k9qa33lq4v50bai45i5701npykdnhlv73lkg2q9mhqprygd4";
      type = "gem";
    };
    version = "3.11.0";
  };
  parallel = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0055br0mibnqz0j8wvy20zry548dhkakws681bhj3ycb972awkzd";
      type = "gem";
    };
    version = "1.20.1";
  };
  parser = {
    dependencies = ["ast"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jixakyzmy0j5c1rb0fjrrdhgnyryvrr6vgcybs14jfw09akv5ml";
      type = "gem";
    };
    version = "3.0.0.0";
  };
  pg = {
    groups = ["production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00vhasqwc4f98qb4wxqn2h07fjwzhp5lwyi41j2gndi2g02wrdqh";
      type = "gem";
    };
    version = "0.21.0";
  };
  pluck_to_hash = {
    dependencies = ["activerecord" "activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zm4a3gcbkzadmk6vmyk7bcfhwnbskbksja158k9hvvi75i9168m";
      type = "gem";
    };
    version = "1.0.2";
  };
  popper_js = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fvd6g0drjfjjiah0zq43xy6ml6my2mhqkh0qcd0iv8qj4ylpv2d";
      type = "gem";
    };
    version = "1.16.0";
  };
  public_suffix = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xqcgkl7bwws1qrlnmxgh8g4g9m10vg60bhlw40fplninb3ng6d9";
      type = "gem";
    };
    version = "4.0.6";
  };
  puma = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ypkyqhysb2vvdvkl4w923yvpmi228gld4kbargb1i2d4sa9s49a";
      type = "gem";
    };
    version = "3.12.6";
  };
  racc = {
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "178k7r0xn689spviqzhvazzvxfq6fyjldxb3ywjbgipbfi4s8j1g";
      type = "gem";
    };
    version = "1.5.2";
  };
  rack = {
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i5vs0dph9i5jn8dfc6aqd6njcafmb20rwqngrf759c9cvmyff16";
      type = "gem";
    };
    version = "2.2.3";
  };
  rack-oauth2 = {
    dependencies = ["activesupport" "attr_required" "httpclient" "json-jwt" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b0h0rlfl0p0drymwfc71g87fp66ck3205pl32z89xsgh0lzw25k";
      type = "gem";
    };
    version = "1.16.0";
  };
  rack-test = {
    dependencies = ["rack"];
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rh8h376mx71ci5yklnpqqn118z3bl67nnv5k801qaqn1zs62h8m";
      type = "gem";
    };
    version = "1.1.0";
  };
  rails = {
    dependencies = ["actioncable" "actionmailer" "actionpack" "actionview" "activejob" "activemodel" "activerecord" "activestorage" "activesupport" "railties" "sprockets-rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nzsm1fqqnhlvgcfrrpsmcv2znldfkyq5c9z7k08p2p54jrd8kfd";
      type = "gem";
    };
    version = "5.2.4.5";
  };
  rails-controller-testing = {
    dependencies = ["actionpack" "actionview" "activesupport"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "151f303jcvs8s149mhx2g5mn67487x0blrf9dzl76q1nb7dlh53l";
      type = "gem";
    };
    version = "1.0.5";
  };
  rails-dom-testing = {
    dependencies = ["activesupport" "nokogiri"];
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lfq2a7kp2x64dzzi5p4cjcbiv62vxh9lyqk2f0rqq3fkzrw8h5i";
      type = "gem";
    };
    version = "2.0.3";
  };
  rails-html-sanitizer = {
    dependencies = ["loofah"];
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1icpqmxbppl4ynzmn6dx7wdil5hhq6fz707m9ya6d86c7ys8sd4f";
      type = "gem";
    };
    version = "1.3.0";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "method_source" "rake" "thor"];
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qwgjwfzkm4q7wby30c9r724w1sp1bywbqfmpv20lq3zdcrf1rfd";
      type = "gem";
    };
    version = "5.2.4.5";
  };
  rainbow = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bb2fpjspydr6x0s8pn1pqkzmxszvkfapv0p4627mywl7ky4zkhk";
      type = "gem";
    };
    version = "3.0.0";
  };
  rake = {
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iik52mf9ky4cgs38fp2m8r6skdkq1yz23vh18lk95fhbcxb6a67";
      type = "gem";
    };
    version = "13.0.3";
  };
  random_password = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07xf3c9qpasmq3pjvl8g5kjr9pycsjwnn13p3zq4fxvbyjffcbf8";
      type = "gem";
    };
    version = "0.1.1";
  };
  rb-fsevent = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k9bsj7ni0g2fd7scyyy1sk9dy2pg9akniahab0iznvjmhn54h87";
      type = "gem";
    };
    version = "0.10.4";
  };
  rb-inotify = {
    dependencies = ["ffi"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jm76h8f8hji38z3ggf4bzi8vps6p7sagxn3ab57qc0xyga64005";
      type = "gem";
    };
    version = "0.10.1";
  };
  recaptcha = {
    dependencies = ["json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1swakxdslkgkca9gkgs686l4r9pzk2yqp3lnvzj2xkid956vkw5w";
      type = "gem";
    };
    version = "5.7.0";
  };
  redcarpet = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bvk8yyns5s1ls437z719y5sdv9fr8kfs8dmr6g8s761dv5n8zvi";
      type = "gem";
    };
    version = "3.5.1";
  };
  redis = {
    groups = ["production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15x2sr6h094rjbvg8pkq6m3lcd5abpyx93aifvfdz3wv6x55xa48";
      type = "gem";
    };
    version = "4.2.5";
  };
  regexp_parser = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vg7imjnfcqjx7kw94ccj5r78j4g190cqzi1i59sh4a0l940b9cr";
      type = "gem";
    };
    version = "2.1.1";
  };
  remote_syslog_logger = {
    dependencies = ["syslog_protocol"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g8h2rfw80ay5yqaj8wddagpagpznk403pxnw6wcxvazrwqcb9h2";
      type = "gem";
    };
    version = "1.0.4";
  };
  representable = {
    dependencies = ["declarative" "declarative-option" "uber"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qm9rgi1j5a6nv726ka4mmixivlxfsg91h8rpp72wwd4vqbkkm07";
      type = "gem";
    };
    version = "3.0.4";
  };
  request_store = {
    dependencies = ["rack"];
    groups = ["default" "production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cx74kispmnw3ljwb239j65a2j14n8jlsygy372hrsa8mxc71hxi";
      type = "gem";
    };
    version = "1.5.0";
  };
  retriable = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q48hqws2dy1vws9schc0kmina40gy7sn5qsndpsfqdslh65snha";
      type = "gem";
    };
    version = "3.1.2";
  };
  rexml = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mkvkcw9fhpaizrhca0pdgjcrbns48rlz4g6lavl5gjjq3rk2sq3";
      type = "gem";
    };
    version = "3.2.4";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b8891149l4rdlaz58k1dprc09rhpvq98bblk4qpd3dvcvqklkvh";
      type = "gem";
    };
    version = "3.9.3";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gjqa3h4r8jna8dh22al4f6ks4x6l4knshx2b8jygkd1gk68n92q";
      type = "gem";
    };
    version = "3.9.4";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19vmdqym1v2g1zbdnq37zwmyj87y9yc9ijwc8js55igvbb9hx0mr";
      type = "gem";
    };
    version = "3.9.1";
  };
  rspec-rails = {
    dependencies = ["actionpack" "activesupport" "railties" "rspec-core" "rspec-expectations" "rspec-mocks" "rspec-support"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w229wsvmj8nbg59kkv4gb4msaff3g1f325i4pw0ibfih7xx31xb";
      type = "gem";
    };
    version = "3.9.1";
  };
  rspec-support = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ig6wk1ln6wy0d6fjlbfwxibps1nidc6111fcnm0jfa1z5nkqczl";
      type = "gem";
    };
    version = "3.9.4";
  };
  rubocop = {
    dependencies = ["parallel" "parser" "rainbow" "regexp_parser" "rexml" "rubocop-ast" "ruby-progressbar" "unicode-display_width"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ncd6w4sc112j86j9j12ws7flxfi8dk8nal2kyxg7phdfr703qlz";
      type = "gem";
    };
    version = "1.10.0";
  };
  rubocop-ast = {
    dependencies = ["parser"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gkf1p8yal38nlvdb39qaiy0gr85fxfr09j5dxh8qvrgpncpnk78";
      type = "gem";
    };
    version = "1.4.1";
  };
  ruby-progressbar = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02nmaw7yx9kl7rbaan5pl8x5nn0y4j5954mzrkzi9i3dhsrps4nc";
      type = "gem";
    };
    version = "1.11.0";
  };
  ruby2_keywords = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15wfcqxyfgka05v2a7kpg64x57gl1y4xzvnc9lh60bqx5sf1iqrs";
      type = "gem";
    };
    version = "0.0.4";
  };
  rubyzip = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0590m2pr9i209pp5z4mx0nb1961ishdiqb28995hw1nln1d1b5ji";
      type = "gem";
    };
    version = "2.3.0";
  };
  sassc = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gpqv48xhl8mb8qqhcifcp0pixn206a7imc07g48armklfqa4q2c";
      type = "gem";
    };
    version = "2.4.0";
  };
  sassc-rails = {
    dependencies = ["railties" "sassc" "sprockets" "sprockets-rails" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d9djmwn36a5m8a83bpycs48g8kh1n2xkyvghn7dr6zwh4wdyksz";
      type = "gem";
    };
    version = "2.1.2";
  };
  sequel = {
    groups = ["production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03g5k8qkya8zljyj3fyh9fcyaj0ff637f5s2vmbqglnhxkzndg7j";
      type = "gem";
    };
    version = "5.41.0";
  };
  shoulda-matchers = {
    dependencies = ["activesupport"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19smdzb2w0xgk8zig3h527absqhd71cdf2bdikldyawbyfw57307";
      type = "gem";
    };
    version = "3.1.3";
  };
  signet = {
    dependencies = ["addressable" "faraday" "jwt" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vvxmfm9khxp35xs8qxc82i7hakylxbn7kx4apinvxaid6rlq60g";
      type = "gem";
    };
    version = "0.15.0";
  };
  simplecov = {
    dependencies = ["docile" "json" "simplecov-html"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sfyfgf7zrp2n42v7rswkqgk3bbwk1bnsphm24y7laxv3f8z0947";
      type = "gem";
    };
    version = "0.16.1";
  };
  simplecov-html = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lihraa4rgxk8wbfl77fy9sf0ypk31iivly8vl3w04srd7i0clzn";
      type = "gem";
    };
    version = "0.10.2";
  };
  spring = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x2wz1y2b0kp7mlk9k8zkl39rddk2l3x34b7dar3bh3axd1cs30d";
      type = "gem";
    };
    version = "2.1.1";
  };
  spring-watcher-listen = {
    dependencies = ["listen" "spring"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ybz9nsngfz4psvgnbr3gdk5ibqqhq47lsjkwh5yq4f8brpr10yz";
      type = "gem";
    };
    version = "2.0.1";
  };
  sprockets = {
    dependencies = ["concurrent-ruby" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "182jw5a0fbqah5w9jancvfmjbk88h8bxdbwnl4d3q809rpxdg8ay";
      type = "gem";
    };
    version = "3.7.2";
  };
  sprockets-rails = {
    dependencies = ["actionpack" "activesupport" "sprockets"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mwmz36265646xqfyczgr1mhkm1hfxgxxvgdgr4xfcbf2g72p1k2";
      type = "gem";
    };
    version = "3.2.2";
  };
  sqlite3 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01ifzp8nwzqppda419c9wcvr8n82ysmisrs0hph9pdmv1lpa4f5i";
      type = "gem";
    };
    version = "1.3.13";
  };
  swd = {
    dependencies = ["activesupport" "attr_required" "httpclient"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c5cdpykx2h4jx8q01hjhv8f0plw5r9iqm2i1m0ijiyk7dqm824w";
      type = "gem";
    };
    version = "1.2.0";
  };
  sync = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z9qlq4icyiv3hz1znvsq1wz2ccqjb1zwd6gkvnwg6n50z65d0v6";
      type = "gem";
    };
    version = "0.5.0";
  };
  syslog_protocol = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yb2cmbyj0zmb2yhkgnmghcngrkhcxs4g1svcmgfj90l2hs23nmc";
      type = "gem";
    };
    version = "0.9.2";
  };
  tabler-rubygem = {
    dependencies = ["autoprefixer-rails"];
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "4c16e6dc930f6b92dec093abaf9652d768b46d97";
      sha256 = "1mypmdd8n04sbwr3y3r995yjmjgfg6cahrwa8gz90a8gnw7pc2g6";
      type = "git";
      url = "https://github.com/blindsidenetworks/tabler-rubygem.git";
    };
    version = "0.1.4.1";
  };
  term-ansicolor = {
    dependencies = ["tins"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xq5kci9215skdh27npyd3y55p812v4qb4x2hv3xsjvwqzz9ycwj";
      type = "gem";
    };
    version = "1.7.1";
  };
  thor = {
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18yhlvmfya23cs3pvhr1qy38y41b6mhr5q9vwv5lrgk16wmf3jna";
      type = "gem";
    };
    version = "1.1.0";
  };
  thread_safe = {
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  tilt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rn8z8hda4h41a64l0zhkiwz2vxw9b1nb70gl37h1dg2k874yrlv";
      type = "gem";
    };
    version = "2.0.10";
  };
  tins = {
    dependencies = ["sync"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00scbhqyxc0h0w1d0gsg6v8yyjxkjkxm50lf9av22xw2k0dl1la6";
      type = "gem";
    };
    version = "1.28.0";
  };
  turbolinks = {
    dependencies = ["turbolinks-source"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "176fbkhhi2jmsnbkcng2qr82nd35qmh3inmbv5dqm9z2qj4misjz";
      type = "gem";
    };
    version = "5.2.1";
  };
  turbolinks-source = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m45pk1jbfvqaki1mxn1bmj8yy65qyv49ygqbkqv08hshpx42ain";
      type = "gem";
    };
    version = "5.2.0";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    groups = ["default" "development" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zwqqh6138s8b321fwvfbywxy00lw1azw4ql3zr0xh1aqxf8cnvj";
      type = "gem";
    };
    version = "1.2.9";
  };
  tzinfo-data = {
    dependencies = ["tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ik16lnsyr2739jzwl4r5sz8q639lqw8f9s68iszwhm2pcq8p4w2";
      type = "gem";
    };
    version = "1.2021.1";
  };
  uber = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p1mm7mngg40x05z52md3mbamkng0zpajbzqjjwmsyw0zw3v9vjv";
      type = "gem";
    };
    version = "0.1.0";
  };
  uglifier = {
    dependencies = ["execjs"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wgh7bzy68vhv9v68061519dd8samcy8sazzz0w3k8kqpy3g4s5f";
      type = "gem";
    };
    version = "4.2.0";
  };
  unicode-display_width = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bilbnc8j6jkb59lrf177i3p1pdyxll0n8400hzqr35vl3r3kv2m";
      type = "gem";
    };
    version = "2.0.0";
  };
  validate_email = {
    dependencies = ["activemodel" "mail"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r1fz29l699arka177c9xw7409d1a3ff95bf7a6pmc97slb91zlx";
      type = "gem";
    };
    version = "0.1.6";
  };
  validate_url = {
    dependencies = ["activemodel" "public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bwj34rz7961rrl545f006m2jdz1nrc0m72gfqmnb41xwsvpagbk";
      type = "gem";
    };
    version = "1.0.13";
  };
  web-console = {
    dependencies = ["actionview" "activemodel" "bindex" "railties"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0win52d8wmrj3prplivv4ppi79gbg83h78nm1mqs4flmhgr7xsfd";
      type = "gem";
    };
    version = "3.7.0";
  };
  webfinger = {
    dependencies = ["activesupport" "httpclient"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m0jh8k7c0ifh2jhbn7ihqrmn5fi754wflva97zgy70hpdvxyjar";
      type = "gem";
    };
    version = "1.1.0";
  };
  webmock = {
    dependencies = ["addressable" "crack" "hashdiff"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08cq0w5rr8znhyas8s3vhwfsd1j5fnvhhdyjr82d6kmh5542b3d9";
      type = "gem";
    };
    version = "3.12.1";
  };
  webrick = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d4cvgmxhfczxiq5fr534lmizkhigd15bsx5719r5ds7k7ivisc7";
      type = "gem";
    };
    version = "1.7.0";
  };
  websocket-driver = {
    dependencies = ["websocket-extensions"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i3rs4kcj0jba8idxla3s6xd1xfln3k8b4cb1dik2lda3ifnp3dh";
      type = "gem";
    };
    version = "0.7.3";
  };
  websocket-extensions = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hc2g9qps8lmhibl5baa91b4qx8wqw872rgwagml78ydj8qacsqw";
      type = "gem";
    };
    version = "0.1.5";
  };
  xml-simple = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1flpmghcbil6qbl3f6w67kpjrnjbw86x7h6g5n4m5ff0cg4sylrv";
      type = "gem";
    };
    version = "1.1.8";
  };
}
