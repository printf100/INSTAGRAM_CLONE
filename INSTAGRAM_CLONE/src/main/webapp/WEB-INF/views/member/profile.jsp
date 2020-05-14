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
	<script type="text/javascript">
		$(function(){
			
			$("#profile_image").click(function(){
				$("#member_img_original_name").click();
			})
			
			$("#member_img_original_name").change(function(e){
				var form = $("#imageForm")[0];
				var formData = new FormData(form);
				
				$.ajax({
					type: "POST",
					enctype: "multipart/form-data",
					url: "/member/updateprofileimage",
					processData: false,
					contentType: false,
					data: formData,
					dataType: "JSON",
					success: function(msg){
						$("#profile_image").attr("src","/resources/images/profileupload/" + msg.img);
					},
					error : function() {
						alert("통신 실패");
					}
				})				
			})
			
		})
	</script>
<!-- END :: board -->
	
	
	
</head>



<body>
	
	<section class="container w-75">
		<div id="header">
			<div class="row">
				
				<!-- 멤버 프로필 이미지 -->
				<div class="col-sm-4">
					<form id="imageForm" action="/member/updateprofileimage" method="POST" enctype="multipart/form-data">
						<input type="hidden" name="member_code" value="${sessionLoginMember.member_code }">
						
						<div class="rounded-circle border w-150 h-150 overflow-hidden mx-auto">						
							<img 
								id="profile_image" 
								class="w-150 h-150 bg-white cursor-pointer"
								src="<c:choose>
										 <c:when test="${not empty sessionLoginMemberProfile.member_img_server_name}">
										 	/resources/images/profileupload/${sessionLoginMemberProfile.member_img_server_name }
										 </c:when>
										 <c:otherwise>
										 	/resources/images/profile/add.png
										 </c:otherwise>
									 </c:choose>"
							>
							<input id="member_img_original_name" type="file" name="member_img_original_name" value="${sessionLoginMemberProfile.member_img_original_name }">					
							
						</div>
						
					</form>
				</div>
				
				<!-- 계정관련 -->
				<div class="col-sm-8">
					<div class="d-flex mb-2">
						<div class="my-auto mx-1">
							<h3>${sessionLoginMember.member_id }</h3>
						</div>
						<div class="my-auto mx-1">
							<button type="button" class="" onclick="location.href='/member/profileEdit'">프로필 편집</button>
						</div>
						<div class="my-auto mx-1">수정

							<h3><a href="/member/profileEdit"><i class="fas fa-cog"></i></a></h3>
						</div>
					</div>
					<div class="mb-2">
						<ul class="navbar-nav list-group-horizontal">
							<li class="nav-item mr-5">게시물 ?</li>
							<li class="nav-item mr-5">팔로워 ?</li>
							<li class="nav-item mr-5">팔로우 ?</li>
							<li class="nav-item mr-5">성별  ?</li>
						</ul>
					</div>
					<div class="mb-2">
						<div>
							${sessionLoginMember.member_name }
						</div>
						<div>
							${sessionLoginMemberProfile.member_introduce }
						</div>
						<div>
							<h3><a href="${sessionLoginMemberProfile.member_website }">${sessionLoginMemberProfile.member_website } 웹 사이트</a></h3>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<div id="contant" class="h-150">
		
		</div>
	</section>
	
	
</body>
</html>