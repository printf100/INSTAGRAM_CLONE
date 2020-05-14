package com.instagram.clone.common.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LogFilter implements Filter {

	private Logger logger = LoggerFactory.getLogger(LogFilter.class);

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// 필터 실행시
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest req = (HttpServletRequest) request;
		// https://tomcat.apache.org/tomcat-5.5-doc/servletapi/javax/servlet/http/HttpServletRequest.html#getHeader(java.lang.String)

		String remoteAddr = req.getRemoteAddr(); // Returns the Internet Protocol (IP) address of the client or last
													// proxy that sent the request.
		String uri = req.getRequestURI(); // Returns the part of this request's URL from the protocol name up to the
											// query string in the first line of the HTTP request.
		String url = req.getRequestURL().toString(); // Reconstructs the URL the client used to make the request.
		String queryString = req.getQueryString(); // Returns the query string that is contained in the request URL
													// after the path.

		// Returns the value of the specified request header as a String.
		String referer = req.getHeader("referer"); // 이전 페이지의 url
		String agent = req.getHeader("User-Agent"); // 유저의 (brower, os 등..)의 정보

		StringBuffer sb = new StringBuffer();
		sb.append("\t* remoteAddr : " + remoteAddr + "\n").append("\t* uri : " + uri + "\n")
				.append("\t* url : " + url + "\n").append("\t* queryString : " + queryString + "\n")
				.append("\t* referer : " + referer + "\n").append("\t* agent : " + agent);

		logger.info("LOG FILTER\n" + sb);

		chain.doFilter(req, response);
	}

	@Override
	public void destroy() {
		// 필터 종료시
	}

}
