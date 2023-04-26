package com.game.web.controller;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.game.common.util.StringUtil;
import com.game.web.model.Notice;
import com.game.web.model.Paging;
import com.game.web.model.Qna;
import com.game.web.model.Report;
import com.game.web.model.Response;
import com.game.web.model.User;
import com.game.web.service.BoardService;
import com.game.web.service.UserService;
import com.game.web.util.CookieUtil;
import com.game.web.util.HttpUtil;
import com.game.web.util.JsonUtil;

@Controller
public class BoardController {
	
	private static Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private UserService userService;
	
	//유저 쿠키 이름
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	//한 페이지당 글 갯수
	private final long PAGE_VIEW = 10;
	
	//한 페이지당 페이징 갯수
	private final long PAGE_LIST = 5;
	
	@RequestMapping(value="/board/notice")
	public String notice(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		long noticeTotalCount = 0;
		List<Notice> list = null;
		Paging paging = null;
		Notice search = new Notice();
		
		if(!StringUtil.isEmpty(searchValue))
		{
			search.setSearchValue(searchValue);
		}
		
		noticeTotalCount = boardService.noticeListCount(search);
		
		logger.debug("================================================");
		logger.debug("noticeTotalCount : " + noticeTotalCount);
		logger.debug("================================================");
		
		if(noticeTotalCount > 0)
		{
			paging = new Paging("board/notice", noticeTotalCount, PAGE_VIEW, PAGE_LIST, curPage, "curPage");
			
			paging.addParam("searchValue", searchValue);
			paging.addParam("curPage", curPage);
			
			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());
			
			list = boardService.noticeList(search);
		}
		
		model.addAttribute("cookieUserId", cookieUserId);
		model.addAttribute("list", list);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		
		return "/board/notice";
	}
	
	@RequestMapping(value="/board/noticeDetail")
	public String noticeDetail(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long noticeSeq = HttpUtil.get(request, "noticeSeq", (long)0);
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);

		Notice notice = null;
		
		if(noticeSeq > 0)
		{
			notice = boardService.noticeSelect(noticeSeq);
		}
		
		model.addAttribute("cookieUserId", cookieUserId);
		model.addAttribute("noticeSeq", noticeSeq);
		model.addAttribute("notice", notice);
		model.addAttribute("searchValue",searchValue);
		model.addAttribute("curPage", curPage);
		
		return "/board/noticeDetail";
	}
	
	@RequestMapping(value="/board/noticeUpdateForm")
	public String noticeUpdateForm(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long noticeSeq = HttpUtil.get(request, "noticeSeq", (long)0);
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)0);
		
		Notice notice = null;
		
		if(noticeSeq > 0 && StringUtil.equals(cookieUserId, "test"))
		{
			notice = boardService.noticeSelect(noticeSeq);
			
			model.addAttribute("searchValue", searchValue);
			model.addAttribute("curPage", curPage);
			model.addAttribute("noticeSeq", noticeSeq);
			model.addAttribute("notice", notice);	
		}
		return "/board/noticeUpdateForm";
	}
	
	@RequestMapping(value="/board/noticeUpdateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> noticeUpdateProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long noticeSeq = HttpUtil.get(request, "noticeSeq", (long)0);
		String noticeTitle = HttpUtil.get(request, "noticeTitle", "");
		String noticeContent = HttpUtil.get(request, "noticeContent", "");
		
		if(noticeSeq > 0 && StringUtil.equals(cookieUserId, "test"))
		{
			Notice notice = boardService.noticeSelect(noticeSeq);
			
			if(notice != null)
			{
				if(StringUtil.equals(cookieUserId, "test"))
				{
					notice.setNoticeSeq(noticeSeq);
					notice.setNoticeTitle(noticeTitle);
					notice.setNoticeContent(noticeContent);
					
					try
					{
						if(boardService.noticeUpdate(notice) > 0)
						{
							ajaxResponse.setResponse(0, "success");
						}
						else
						{
							ajaxResponse.setResponse(500, "Internal Server Error2");
						}
					}
					catch(Exception e)
					{
						logger.error("[BoardController] /board/noticeUpdateProc Exception", e);
						ajaxResponse.setResponse(500, "Internal Server Error");
					}
				}
				else
				{
					ajaxResponse.setResponse(404, "Not Found2");
				}
			}
			else
			{
				ajaxResponse.setResponse(404, "Not Found");
			}
			
		}
		else
		{
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[BoardController] /board/noticeUpdateProc response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	@RequestMapping(value="/board/noticeDelete", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> noticeDelete(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long noticeSeq = HttpUtil.get(request, "noticeSeq", (long)0);
		
		if(noticeSeq > 0)
		{
			Notice notice = boardService.noticeSelect(noticeSeq);
			
			if(notice != null)
			{
				if(StringUtil.equals(cookieUserId, "test"))
				{
					try
					{
						if(boardService.noticeDelete(notice.getNoticeSeq()) > 0)
						{
							ajaxResponse.setResponse(0, "success");
						}
						else
						{
							ajaxResponse.setResponse(500, "Internal Server Error2");
						}
						
					}
					catch(Exception e)
					{
						logger.error("[BoardController] /board/noticeDelete Exception", e);
						ajaxResponse.setResponse(500, "Internal Server Error");
					}
				}
				else
				{
					ajaxResponse.setResponse(404, "Not Found2");
				}
			}
			else
			{
				ajaxResponse.setResponse(404, "Not Found");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[BoardController] /board/noticeDelete response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	@RequestMapping(value="/board/noticeRegForm")
	public String noticeRegForm(HttpServletRequest request, HttpServletResponse response)
	{
		return "/board/noticeRegForm";
	}
	
	@RequestMapping(value="/board/noticeWriteProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> noticeWriteProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String noticeTitle = HttpUtil.get(request, "noticeTitle", "");
		String noticeContent = HttpUtil.get(request, "noticeContent", "");
		
		if(!StringUtil.isEmpty(noticeTitle) && !StringUtil.isEmpty(noticeContent))
		{
			Notice notice = new Notice();
			
			notice.setAdminId(cookieUserId);
			notice.setNoticeTitle(noticeTitle);
			notice.setNoticeContent(noticeContent);
			
			try
			{
				if(boardService.noticeInsert(notice) > 0)
				{
					ajaxResponse.setResponse(0, "success");
				}
				else
				{
					ajaxResponse.setResponse(500, "Internal Server Error");
				}
			}
			catch(Exception e)
			{
				logger.error("[BoardController]/board/noticeWriteProc/Exception", e);
				ajaxResponse.setResponse(500, "Internal Server Error");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "Bad Request");
		}
		return ajaxResponse;
	}
	
	@RequestMapping(value="/board/qna")
	public String qna(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		long qnaTotalCount = 0;
		List<Qna> list = null;
		Paging paging = null;
		Qna search = new Qna();
		
		if(!StringUtil.isEmpty(cookieUserId))
		{
			search.setUserId(cookieUserId);
		}
		
		if(!StringUtil.isEmpty(searchValue))
		{
			search.setSearchValue(searchValue);
		}
		
		qnaTotalCount = boardService.qnaListCount(search);
		
		logger.debug("================================================");
		logger.debug("qnaTotalCount : " + qnaTotalCount);
		logger.debug("================================================");
		
		if(qnaTotalCount > 0)
		{
			paging = new Paging("board/qna", qnaTotalCount, PAGE_VIEW, PAGE_LIST, curPage, "curPage");
			
			paging.addParam("searchValue", searchValue);
			paging.addParam("userId", cookieUserId);
			paging.addParam("curPage", curPage);
			
			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());
			
			list = boardService.qnaList(search);
		}
		
		model.addAttribute("list", list);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		
		return "/board/qna";
	}
	
	@RequestMapping(value="/board/qnaRegForm")
	public String qnaRegForm(ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if(StringUtil.isEmpty(cookieUserId))
		{
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>alert('로그인이 필요합니다.'); location.href='/user/login';</script>");
			out.flush();
		}
		return "/board/qnaRegForm";
	}
	
	@RequestMapping(value="/board/qnaWriteProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> qnaWriteProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String qnaTitle = HttpUtil.get(request, "qnaTitle", "");
		String qnaContent = HttpUtil.get(request, "qnaContent", "");
		String qnaStatus = HttpUtil.get(request, "qnaStatus", "N");
		
		if(!StringUtil.isEmpty(qnaTitle) && !StringUtil.isEmpty(qnaContent))
		{
			Qna qna = new Qna();
			
			qna.setUserId(cookieUserId);
			qna.setQnaTitle(qnaTitle);
			qna.setQnaContent(qnaContent);
			qna.setQnaStatus(qnaStatus);
			
			try
			{
				if(boardService.qnaInsert(qna) > 0)
				{
					ajaxResponse.setResponse(0, "success");
				}
				else
				{
					ajaxResponse.setResponse(500, "Internal Server Error");
				}
			}
			catch(Exception e)
			{
				logger.error("[BoardController]/board/qnaWriteProc/Exception", e);
				ajaxResponse.setResponse(500, "Internal Server Error");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "Bad Request");
		}
		return ajaxResponse;
	}
	
	@RequestMapping(value="/board/qnaDetail")
	public String qnaDetail(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long qnaSeq = HttpUtil.get(request, "qnaSeq", (long)0);
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		String qnaStatus = HttpUtil.get(request, "qnaStatus", "");
		
		// 본인 글 여부
		String boardMe = "N";
		
		// 문의글
		Qna qna = null;
		
		// 문의 답변글
		Qna qnaReply = null;
		
		if(qnaSeq > 0)
		{
			qna = boardService.qnaSelect(qnaSeq);
			qnaReply = boardService.qnaReplySelect(qnaSeq);
			
			if(qna != null && StringUtil.equals(qna.getUserId(), cookieUserId))
			{
				boardMe = "Y";
			}
		}
		
		model.addAttribute("cookieUserId", cookieUserId);
		model.addAttribute("qnaSeq", qnaSeq);
		model.addAttribute("qna", qna);
		model.addAttribute("boardMe", boardMe);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("qnaStatus", qnaStatus);
		
		model.addAttribute("qnaReply", qnaReply);
		
		return "/board/qnaDetail";
	}
	
	@RequestMapping(value="/board/qnaUpdateForm")
	public String qnaUpdateForm(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long qnaSeq = HttpUtil.get(request, "qnaSeq", (long)0);
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)0);
		
		Qna qna = null;
		
		if(qnaSeq > 0)
		{
			qna = boardService.qnaSelect(qnaSeq);
			
			if(!StringUtil.equals(qna.getUserId(), cookieUserId))
			{
				qna = null;
			}
			
			model.addAttribute("searchValue", searchValue);
			model.addAttribute("curPage", curPage);
			model.addAttribute("qnaSeq", qnaSeq);
			model.addAttribute("qna", qna);
			
		}
		return "/board/qnaUpdateForm";
	}
	
	@RequestMapping(value="/board/qnaUpdateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> qnaUpdateProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long qnaSeq = HttpUtil.get(request, "qnaSeq", (long)0);
		String qnaTitle = HttpUtil.get(request, "qnaTitle", "");
		String qnaContent = HttpUtil.get(request, "qnaContent", "");
		
		if(qnaSeq > 0 && !StringUtil.isEmpty(qnaTitle) && !StringUtil.isEmpty(qnaContent))
		{
			Qna qna = boardService.qnaSelect(qnaSeq);
			
			if(qna != null)
			{
				if(StringUtil.equals(qna.getUserId(), cookieUserId))
				{
					qna.setQnaSeq(qnaSeq);
					qna.setQnaTitle(qnaTitle);
					qna.setQnaContent(qnaContent);
					
					try
					{
						if(boardService.qnaUpdate(qna) > 0)
						{
							ajaxResponse.setResponse(0, "success");
						}
						else
						{
							ajaxResponse.setResponse(500, "Internal Server Error2");
						}
					}
					catch(Exception e)
					{
						logger.error("[BoardController] /board/qnaUpdateProc Exception", e);
						ajaxResponse.setResponse(500, "Internal Server Error");
					}
				}
				else
				{
					ajaxResponse.setResponse(404, "Not Found2");
				}
			}
			else
			{
				ajaxResponse.setResponse(404, "Not Found");
			}
			
		}
		else
		{
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[BoardController] /board/qnaUpdateProc response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	@RequestMapping(value="/board/qnaDelete", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> qnaDelete(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long qnaSeq = HttpUtil.get(request, "qnaSeq", (long)0);
		
		if(qnaSeq > 0)
		{
			Qna qna = boardService.qnaSelect(qnaSeq);
			
			if(qna != null)
			{
				if(StringUtil.equals(cookieUserId, "test") || StringUtil.equals(qna.getUserId(), cookieUserId))
				{
					try
					{
						// 답변글이 존재하는지 확인
						if(boardService.qnaAnswersCount(qna.getQnaSeq()) > 0)
						{
							ajaxResponse.setResponse(-999, "Answers Exist And Cannot Be Delete");
						}
						else
						{
							if(boardService.qnaDelete(qna.getQnaSeq()) > 0)
							{
								ajaxResponse.setResponse(0, "success");
							}
							else
							{
								ajaxResponse.setResponse(500, "Internal Server Error2");
							}
						}
					}
					catch(Exception e)
					{
						logger.error("[BoardController] /board/qnaDelete Exception", e);
						ajaxResponse.setResponse(500, "Internal Server Error");
					}
				}
				else
				{
					ajaxResponse.setResponse(404, "Not Found2");
				}
			}
			else
			{
				ajaxResponse.setResponse(404, "Not Found");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[BoardController] /board/qnaDelete response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	@RequestMapping(value="/board/qnaReplyProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> qnaReplyProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long qnaSeq = HttpUtil.get(request, "qnaSeq", (long)0);
		String qnaReplyContent = HttpUtil.get(request, "qnaReplyContent", "");
		
		System.out.println("===============================================");
		System.out.println(qnaReplyContent);
		System.out.println("===============================================");
		
		if(qnaSeq > 0 && !StringUtil.isEmpty(qnaReplyContent))
		{
			Qna parentQna = boardService.qnaSelect(qnaSeq);
			
			if(parentQna != null)
			{
				Qna qna = new Qna();
				qna.setUserId(cookieUserId);
				qna.setQnaTitle(parentQna.getQnaTitle());
				qna.setQnaContent(qnaReplyContent);
				qna.setQnaParent(qnaSeq);
				
				try
				{
					if(boardService.qnaReplyInsert(qna) > 0)
					{
						ajaxResponse.setResponse(0, "success");
						boardService.qnaStatusUpdate(qnaSeq);
					}
					else
					{
						ajaxResponse.setResponse(500, "Internal Serverr Error2");
					}
				}
				catch(Exception e)
				{
					logger.error("[BoardController] /board/qnaReplyProc Exception", e);
					ajaxResponse.setResponse(500, "Internal Serverr Error1");
				}
			}
			else
			{
				ajaxResponse.setResponse(404, "Not Found"); // 부모글이 없을경우
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		return ajaxResponse;
	}
	
	@RequestMapping(value="/board/reportList")
	public String reportList(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		long reportSeq = HttpUtil.get(request, "reportSeq", (long)0);
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME,"");
		String searchPr = HttpUtil.get(request, "searchPr", "");
		String searchTag = HttpUtil.get(request, "searchTag", "");
		String searchValueOption = HttpUtil.get(request, "searchValueOption", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		long reportTotalCount = 0;
		List<Report> list = null;
		Paging paging = null;
		Report search = new Report();
		User user = null;
		if(!StringUtil.isEmpty(cookieUserId))
		{
			user = userService.userSelect(cookieUserId);
			if(user != null)
			{
				if(user.getUserClass() != 'a')
				{
					return "redirect:/";
				}
			}
			else
			{
				return "redirect:/";
			}
		}
		else
		{
			return "redirect:/";
		}
		
		if(!StringUtil.isEmpty(searchPr))
		{
			if(StringUtil.equals(searchPr, "상품"))
			{
				searchPr = "P";
				search.setSearchPr(searchPr);
			}
			
			if(StringUtil.equals(searchPr, "리뷰"))
			{	
				searchPr = "R";
				search.setSearchPr(searchPr);
			}
		}
		
		if(!StringUtil.isEmpty(searchTag))
		{
			search.setSearchTag(searchTag);
		}
		
		if(!StringUtil.isEmpty(searchValue))
		{
			search.setSearchValue(searchValue);
		}
		
		if(!StringUtil.isEmpty(searchValueOption))
		{
			search.setSearchValueOption(searchValueOption);
		}
		
		reportTotalCount = boardService.reportListCount(search);
		
		logger.debug("================================================");
		logger.debug("reportTotalCount : " + reportTotalCount);
		logger.debug("================================================");
		
		if(reportTotalCount > 0)
		{
			paging = new Paging("board/reportList", reportTotalCount, PAGE_VIEW, PAGE_LIST, curPage, "curPage");
			
			paging.addParam("reportSeq", reportSeq);
			paging.addParam("searchPr", searchPr);
			paging.addParam("searchTag", searchTag);
			paging.addParam("searchValueOption", searchValueOption);
			paging.addParam("searchValue", searchValue);
			paging.addParam("curPage", curPage);
			
			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());
			
			list = boardService.reportList(search);
		}
		
		model.addAttribute("reportSeq", reportSeq);
		model.addAttribute("list", list);
		model.addAttribute("searchPr", searchPr);
		model.addAttribute("searchTag", searchTag);
		model.addAttribute("searchValueOption", searchValueOption);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		
		return "/board/reportList";
	}
	
	@RequestMapping(value="/board/reportDetail")
	public String reportDetail(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long reportSeq = HttpUtil.get(request, "reportSeq", (long)0);
		String searchPr = HttpUtil.get(request, "searchPr", "");
		String searchTag = HttpUtil.get(request, "searchTag", "");
		String searchValueOption = HttpUtil.get(request, "searchValueOption", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		String reportStatus = HttpUtil.get(request, "reportStatus", "");
		
		Report report = null;
		
		if(reportSeq > 0)
		{
			report = boardService.reportSelect(reportSeq);
		}
		
		model.addAttribute("cookieUserId", cookieUserId);
		model.addAttribute("reportSeq", reportSeq);
		model.addAttribute("report", report);
		model.addAttribute("searchPr", searchPr);
		model.addAttribute("searchTag", searchTag);
		model.addAttribute("searchValueOption", searchValueOption);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("reportStatus", reportStatus);
		
		return "/board/reportDetail";
	}
	
	@RequestMapping(value="/board/reportStatusUpdateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> reportStatusUpdateProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long reportSeq = HttpUtil.get(request, "reportSeq", (long)0);
		String reportStatus = HttpUtil.get(request, "reportStatus", "");
		
		if(reportSeq > 0 && !StringUtil.isEmpty(reportStatus))
		{
			Report report = boardService.reportSelect(reportSeq);
			
			if(report != null)
			{
				if(StringUtil.equals(cookieUserId, "test"))
				{
					report.setReportSeq(reportSeq);
					if(StringUtil.equals(reportStatus, "미처리"))
					{
						reportStatus = "N";
						report.setReportStatus(reportStatus);
					}
					if(StringUtil.equals(reportStatus, "처리완료"))
					{
						reportStatus = "Y";
						report.setReportStatus(reportStatus);
					}
					
					try
					{
						if(boardService.reportStatusUpdate(report) > 0)
						{
							ajaxResponse.setResponse(0, "success");
						}
						else
						{
							ajaxResponse.setResponse(500, "Internal Server Error2");
						}
					}
					catch(Exception e)
					{
						logger.error("[BoardController] /board/reportStatusUpdateProc Exception", e);
						ajaxResponse.setResponse(500, "Internal Server Error");
					}
				}
				else
				{
					ajaxResponse.setResponse(404, "Not Found2");
				}
			}
			else
			{
				ajaxResponse.setResponse(404, "Not Found");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[BoardController] /board/reportStatusUpdateProc response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	//신고등록 메서드
	@RequestMapping(value="/board/reportWriteProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> reportWriteProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String reportPr = HttpUtil.get(request, "reportPr", "");
		String reportProductTag = HttpUtil.get(request, "reportProductTag", "");
		String reportReviewTag = HttpUtil.get(request, "reportReviewTag", "");
		String reportContent = HttpUtil.get(request, "reportContent", "");
		long productSeq = HttpUtil.get(request, "report_product_seq",(long)0);
		long reviewSeq = HttpUtil.get(request, "report_review_seq", (long)0);
		
		if(!StringUtil.isEmpty(reportPr) && !StringUtil.isEmpty(reportContent))
		{
			Report report = new Report();
			
			
			report.setUserId(cookieUserId);
			report.setReportTag(reportProductTag);
			report.setReportContent(reportContent);
			
			if(StringUtil.equals(reportPr, "상품"))
			{
				if(!StringUtil.isEmpty(reportProductTag))
				{
				reportPr = "P";
				report.setReportPr(reportPr);
				report.setProductSeq(productSeq);
				}
				else
				{
					ajaxResponse.setResponse(400, "Bad Request");
					return ajaxResponse;
				}
			}
			if(StringUtil.equals(reportPr, "리뷰"))
			{
				if(!StringUtil.isEmpty(reportReviewTag))
				{
				reportPr = "R";
				report.setReportPr(reportPr);
				report.setReviewSeq(reviewSeq);
				}
				else
				{
					ajaxResponse.setResponse(400, "Bad Request");
					return ajaxResponse;
				}
			}
			
			try
			{
				if(boardService.reportInsert(report) > 0)
				{
					ajaxResponse.setResponse(0, "success");
				}
				else
				{
					ajaxResponse.setResponse(500, "Internal Server Error");
				}
			}
			catch(Exception e)
			{
				logger.error("[BoardController]/board/reportWriteProc/Exception", e);
				ajaxResponse.setResponse(500, "Internal Server Error");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "Bad Request");
		}
		return ajaxResponse;
	}
}
