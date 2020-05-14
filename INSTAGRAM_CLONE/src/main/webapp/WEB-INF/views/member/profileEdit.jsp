<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- START :: HEADER FORM -->
<%@ include file="../form/header.jsp"%>
<!-- END :: HEADER FORM -->

<!-- START :: board -->
<script type="text/javascript"
	src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script type="text/javascript">
	$(function() {

		$("#profile_image").click(function() {
			$("#member_img_original_name").click();
		})

		$("#member_img_original_name").change(
				function(e) {
					var form = $("#imageForm")[0];
					var formData = new FormData(form);

					$.ajax({
						type : "POST",
						enctype : "multipart/form-data",
						url : "/member/updateprofileimage",
						processData : false,
						contentType : false,
						data : formData,
						dataType : "JSON",
						success : function(msg) {
							$("#profile_image").attr(
									"src",
									"/resources/images/profileupload/"
											+ msg.img);
						},
						error : function() {
							alert("통신 실패");
						}
					})
				})
		$(function() {
			$("#joinchk").hide();

			$("#member_email").keyup(
					function() {
						var member_email = $("#member_email").val().trim();
						console.log(member_email)
						var joinVal = {
							"member_email" : member_email
						}

						$.ajax({
							type : "post",
							url : "/member/ajaxemailcheck",
							data : JSON.stringify(joinVal),
							contentType : "application/json",
							dataType : "json",

							success : function(msg) {

								if (msg.check == true) {
									$("#joinchk").show().html(
											"이미 존재하는 EMAIL 입니다.").css("color",
											"red")
								} else {
									$("#joinchk").show().html(
											"사용가능한 EMAIL 입니다.").css("color",
											"green")
								}

							},

							error : function() {
								alert("통신실패");
							}
						})
					})

			$("#member_id").keyup(
					function() {
						var member_id = $("#member_id").val().trim();
						var joinVal = {
							"member_id" : member_id
						}

						$.ajax({
							type : "post",
							url : "/member/ajaxidcheck",
							data : JSON.stringify(joinVal),
							contentType : "application/json",
							dataType : "json",

							success : function(msg) {

								if (msg.check == true) {
									$("#joinchk").show()
											.html("이미 존재하는 ID 입니다.").css(
													"color", "red")
								} else {
									$("#joinchk").show().html("사용가능한 ID 입니다.")
											.css("color", "green")
								}

							},

							error : function() {
								alert("통신실패");
							}
						})
					})
		})

	})
	function test() {
		var member_email = $("#member_email").val().trim();
		var member_name = $("#member_name").val().trim();
		
		if (member_email == null || member_email == "" || member_name == null
				|| member_name == "") {

			alert("EMAIL, NAME 를 모두 입력해주세요!")

		} else if ($("#joinchk").html() == "이미 존재하는 EMAIL 입니다.") {

			alert("이미 존재하는 EMAIL 입니다!!");
			$("#member_email").val("");
			$("#member_email").focus();

		} else {

			$("#profileUpdateForm").submit();

		}
	}
</script>
<!-- END :: board -->
</head>
<body>
	<section class="container w-75">
		<div id="header">
			<div class="row">

				<!-- 멤버 프로필 이미지 -->
				<div class="col-sm-4">
					<form id="imageForm" action="/member/updateprofileimage"
						method="POST" enctype="multipart/form-data">
						<input type="hidden" name="member_code"
							value="${sessionLoginMember.member_code }">

						<div
							class="rounded-circle border w-150 h-150 overflow-hidden mx-auto">
							<img id="profile_image"
								class="w-150 h-150 bg-white cursor-pointer"
								src="<c:choose>
										 <c:when test="${not empty sessionLoginMemberProfile.member_img_server_name}">
										 	/resources/images/profileupload/${sessionLoginMemberProfile.member_img_server_name }
										 </c:when>
										 <c:otherwise>
										 	/resources/images/profile/add.png
										 </c:otherwise>
									 </c:choose>">
							<input id="member_img_original_name" type="file"
								name="member_img_original_name"
								value="${sessionLoginMemberProfile.member_img_original_name }">
						</div>
					</form>
				</div>
			</div>
		</div>
		<br>
		<hr>
		<div>
			<form id="profileUpdateForm" action="/member/profileUpdate"
				method="post">
				<input type="hidden" name="member_code" value="${sessionLoginMember.member_code }">
				<ul>
					<li>이름 <input name="member_name" id="member_name"
						placeholder="이름" type="text"></li>
					<li>email <input name="member_email" id="member_email"
						placeholder="email" type="text"></li>
					<li>웹사이트 <input name="member_website" id="member_website"
						placeholder="웹 사이트" type="text"></li>
					<li>소개 <input name="member_introduce" id="member_introduce"
						placeholder="소개" type="text"></li>
					<li>성별 <select name="member_gender" id="member_gender">
							<option value="남자">남자</option>
							<option value="여자">여자</option>
							<option value="밝히고 싶지 않음">밝히고 싶지 않음</option>
					</select></li>
				</ul>
				<input type="button" value="완료" onclick="test();">
				<div id="joinchk"></div>
			</form>
		</div>
	</section>
</body>
</html>