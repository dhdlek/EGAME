function categoryChange(e) {
    var report_tag_a = ["저작권위반", "아동학대", "법률위반", "악성코드", "사기", "카테고리", "기타"];
    var report_tag_b = ["홍보글", "음란성", "혐오"];
    var target = document.getElementById("report_tag");

    if(e.value == "a") var d = report_tag_a;
	else if(e.value == "b") var d = report_tag_b;

	target.options.length = 0;

	for (x in d) {
		var opt = document.createElement("option");
		opt.value = d[x];
		opt.innerHTML = d[x];
		target.appendChild(opt);
	}	
}