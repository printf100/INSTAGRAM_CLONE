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

<!-- START :: feed -->
	<script type="text/javascript">
	
		/* 무한 스크롤 eventListner */
		let isEnd = false;
		let startNo = 0;
		let searchNo = 0;
	
		$(function(){	
			
			$(window).scroll(function(){
				var scrollTop = $(window).scrollTop();	// 현재 브라우저 스크롤이 있는 위치
				var documentHeight = $(document).height();	// 문서의 총 높이
				var windowHeight = $(window).height();	// 브라우저에 보여지는 높이
				
				console.log(
						"documentHeight : " + $(document).height()
						+ " | scrollTop : " + $(window).scrollTop() 
						+ " | windowHeight : " + $(window).height()
						+ " | scrollTop + windowHeight = " + ($(window).scrollTop() + $(window).height())
						);
				
				if(documentHeight < scrollTop + windowHeight + 1){
					selectFeedList();	
				}
			})
			
			selectFeedList();	
		})
	
		/* feed List ajax 통신 */
		function selectFeedList(){	
			if(isEnd == true)
				return;
			
			$.getJSON("/feed/feedlist?startNo=" + startNo , function(data){
				// 가져온 데이터가 20개 이하 (막지막 sub리스트)일 경우 무한 스크롤 종료
				let length = data.length;
				if(length < 20){
					isEnd = true;
					console.log("******마지막 컨텐츠까지 다 가져옴******")
				}
				fillFeedList(data)		 
			})	
			startNo += 20;
		}
		
		/* feed list 뿌리기 */
		function fillFeedList(data){	
			
			$.each(data, function(index, item){
				console.log(item.LECTURE_CODE)
				
				// 강의 div
				var lectureItem = $("<div>").attr({
					"class" : "lecture card m-4"
				})
				
				// 강의 링크버튼 opacity
				var add_my_lecture = 
						$("<div>").attr({"class":"add_my_lecture_img_container","style":"text-align:right;"})
						.append($("<img src='l m/resources/images/heart.png'>").attr({
							"class":"add_my_lecture_img",
							"data-toggle":"tooltip",
							"title":"MY LECTURE 에 추가하기"
							})) 
				
				var lecture_back = $("<div>").attr({
					"class" : "lecture_back card p-3"
				})
				.append($("<div>").attr({"style":"height:90%; overflow: hidden;"})
						.append($("<h4>").text(item.LECTURE_TITLE).attr("style","color: white;"))
						.append($("<div>").text(item.LECTURE_DESCRIPTION).attr({"class":"pt-3","style":"color: white;"}))
						)
				.append(add_my_lecture)
				
				// 이미지 관련 div
				var lecture_img_div = $("<div>").attr({"class" : "lecture_img_div"})
				var lecture_img = $("<img>").attr({"src" : item.LECTURE_IMG,"style" : "width: 100%; height: 100%; object-fit: cover;"})			
				lecture_img_div.append(lecture_img);
				
				// 강의 정보 div
				var lecture_des_div = $("<div>").attr({
					"class" : "lecture_des_div p-3"
				});
				var lecture_title = $("<h5>").attr({"class":"font-weight-bold"}).text(item.LECTURE_TITLE);		// 제목		
				var lecture_additional_des = $("<div>").attr({"class":"lecture_additional_des row py-4 px-1"}) // 부가정보		
				var lecture_rate = $("<div>").attr({"class":"col-sm-6"})
									.append($("<div>").append(   $("<div>").attr({"class":"star-rating"}).append($("<span>").attr({"class":"rear-start","style":"width:"+item.LECTURE_RATE*20+"%;"}))  )  )
									.append($("<div>").text(item.LECTURE_READCOUNT+"개의 후기"));// 별점, 후기갯수
	
				var lecture_payflag = $("<div>").attr({"class":"col-sm-6", "style":"text-align: right;"}).text(item.LECTURE_PAYFLAG);// 가격		
				lecture_additional_des.append(lecture_rate).append(lecture_payflag);		
				lecture_des_div.append(lecture_title).append(lecture_additional_des);
				
				// 강의 div 에 append 하여 content 완성
				lectureItem.append(lecture_back);
				lectureItem.append(lecture_img_div);
				lectureItem.append(lecture_des_div);
				
				$("#feedListContainer").append(lectureItem);
			})
	
		}
	</script>
<!-- END :: feed -->
</head>

<body>
	
	<section class="container w-75">
		<div class="row">
			
			<!-- 게시물 -->
			<div class="col-sm-8">
				<div id="feedListContainer"></div>
			</div>
			
			<!-- 계정관련 -->
			<div class="col-sm-4">
			
			</div>
		</div>
	</section>
	
	
</body>
</html>