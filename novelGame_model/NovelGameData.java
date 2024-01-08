package novelGame_model;

public class NovelGameData {
	
	private int scene;
	private int route;
	private int energy;
	private int information;

	// 以降の配列はすべて[scene][0またはroute(選択したもの)]が入る。

	// 各シーンの選択画面のテキスト。[シーン番号][0]が状況説明、[][1]以降が各選択肢。
	private static final String[][] SELECTTEXT = {
		{"このストーリーは私がプログラミングを学ぶ過程で遭遇した出来事を描いたものです。\n"
				+ "元気値が0にならないようにしながら、知識値100を目指しましょう。"
				, "start"
				, "exit"},
		{"リファクタリングではなく置換を使って変数名を変更してしまった。"
				, "似た名前の変数名はないし大丈夫だろう"
				, "念のためリファクタリングでやり直す"},
		{"パソコン画面と数時間に渡り睨み合っている。\n"
				+ "一向に解決の糸口がつかめない。"
				, "粘って頑張る"
				, "諦めて帰る"},
		{"エラーメッセージが表示された。"
				, "エラーを翻訳する"
				, "ソースコードを見直す"},
		{"ずっと座って作業していると体が痛くなってきた。"
				, "pcスタンドやスタンディングデスクの購入を検討する"
				, "階段の段差を利用したり、本を積んで高さを調整する"
				, "諦めて座る"},
		{"他者のソースコードを手直しすることになった。"
				, "修正点を確認する"
				, "ゼロから作り直す"},
		{"次のソースコードの問題点が発見できない。\n"
				+ "int numberOne0bject = 1;"
				, "「スペース」の部分を確認してみる"
				, "「numberOne0bject」の部分を確認してみる"
				, "「1」の部分を確認してみる"},
		{"作業が煮詰まってきて、頭がうまく働かない。"
				, "独り言を口ずさむ"
				, "デスクに突っ伏す"
				, "今なら悟りを開けそうだ"},
		{"いよいよ学習も大詰め。\n"
				+ "集大成として就職に向けてポートフォリオを作ろう。"
				, "学んだ知識で何を作ろうか。\nどこまでできるか楽しみだ"
				, "何をすればいいかわからず、デスクの上の整理に力を注いだ"},
		{"","",""}// error対策の数合わせ
	};

	// 各シーンの結果画面のテキスト。[シーン番号][0]をルート1、[][1]以降各ルートが続く。
	private static final String[][] RESULTTEXT = {
		{"「技術力のある人間になりたい！」\n"
				+ "そう考えた私はプログラミングを学ぶことにした。\n"
				+ "意気込みを新たに職業訓練校web.javaプログラミング科に通い始める。"
				,""},
		{"変数entを置換したらクラスStatementまで置換されていた。\n後々苦労した。"
				, "何事もなくスムーズに作業できた。"},
		{"思うように頭が回らず結局解決できなかった。"
				, "自宅でシャワーを浴びていると、突如頭に閃きが走った。\n"
				+ "そうか！あの部分はああすれば良かったんだ！\n"
				+ "問題はいつも唐突に解決する。"},
		{"翻訳したら、ほとんど英語で帰ってきて結局読めない。\n"
				+ "しかし色々調べることでデバックの技術は向上した。"
				, "一時間後、「;」のつけ忘れだと気付く。"},
		{"思いのほか高価なので二の足を踏む。\n"
				+ "なんでも寝ころびながら操作できるらしい。"
				,"快適な作業環境を手に入れた。しかし家族には怒られた。" 
				, "腰が痛いが、学習は進んだ"},
		{"自分のものとは違うコーディングが多く、苦戦する。\n"
				+ "いっそのこと一から作り直した方が速そうだ。"
				, "新たな学びは少なかったがスムーズに進んだ。"},
		{"全角がまぎれているかと思ったが、そんなことはなかった。\n"
				+ "結局何が原因なのかわからない。"
				, "よく見ると「O(オー)」だと思っていたものが「0(ゼロ)」だった。\n"
						+ "こんなものわかるわけない。"
				, "全角の「1」かと思ったが、そんなことはなかった。\n"
				+ "結局何が原因なのかわからない。"},
		{"独り言で自分を客観視できた。どうにも同じ言葉を繰り返してしまっている。\n"
				+ "しかしその様子を見て助っ人が現れた。\n助けてもらうのも時には大切。"
				, "少し休んだら、集中力が戻った。\nおかげで作業が進んだ。"
				, "時々そんなことを考えてしまったりする。"},
		{"デスクは汚いがアプリケーションはそこそこきれいに完成した。\n"
				+"バグやエラー、色々苦労したが、そのおかげで成長できた。\n"
				+"何度も何度も少しずつ改良していく、それがプログラミングなのだろう"
				, "バグだらけのアプリケーションが完成した。\n"
				+ "自分でもなぜ動いているのかよくわからない。"},
		{"",""}// error対策の数合わせ
	};

	// 選択結果による元気の増減値。RESULTTEXTと同様に0をルート1。以降が続く。
	private static final int[][] ENERGYUPDOWN = {
		{100,0},
		{-25,0},
		{-25,10},
		{-15,-25},
		{0,-15,-25},
		{-25,-15},
		{-5,-20,-5},
		{-15,-5,0},
		{0,-100},
		{0,0}// error対策の数合わせ
	};

	// 選択結果による知識の増加値。RESULTTEXTと同様に0をルート1。以降が続く。
	private static final int[][] INFORMATIONUPDOWN = {
		{0,0},
		{20,0},
		{15,20},
		{20,15},
		{0,15,25},
		{20,15},
		{0,15,0},
		{20,20,0},
		{0,0},
		{0,0}// error対策の数合わせ
	};

	// 各シーンの背景画像。SELECTTEXTと連動する。
	private static final String BACKPIC[][] = {
		{"start", "0-1", ""},
		{"main", "1-1", "1-2"},
		{"main", "2-1", "2-2"},
		{"main", "3-1", "3-2"},
		{"main", "4-1", "4-2", "4-3"},
		{"main", "5-1", "5-2"},
		{"main", "6-1.3", "6-2", "6-1.3"},
		{"main", "7-1", "7-2", "7-3"},
		{"main", "8-1", "8-2"},
		{"","",""}// error対策の数合わせ
	};
	
	// シーンとルートの数を取得するメソッド
	public int getSceneCount() {
		return SELECTTEXT.length;
	}
	
	public int getOnesceneRouteCount(int scene) {
		return SELECTTEXT[scene].length;
	}
	
	
	// getterとsetterメソッド
	public void setScene(int scene) {
		this.scene = scene;
	}

	public int getScene() {
		return scene;
	}

	public void setRoute(int route) {
		this.route = route;
	}

	public int getRoute() {
		return route;
	}

	public void setEnergy(int energy) {
		this.energy = energy;
	}

	public int getEnergy() {
		return energy;
	}

	public void setInformation(int information) {
		this.information = information;
	}

	public int getInformation() {
		return information;
	}

	public static String getSelectText(int scene, int route) {
		return SELECTTEXT[scene][route];
	}

	public static String getResultText(int scene, int route) {
		return RESULTTEXT[scene][route-1];
	}

	public static int getEnergyUpDown(int scene, int route) {
		return ENERGYUPDOWN[scene][route-1];
	}

	public static int getInformationUpDown(int scene, int route) {
		return INFORMATIONUPDOWN[scene][route-1];
	}

	public static String getBackPic(int scene, int route) {
		return BACKPIC[scene][route];
	}

}
