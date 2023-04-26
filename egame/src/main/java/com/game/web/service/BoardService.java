package com.game.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.game.web.dao.BoardDao;
import com.game.web.model.Notice;
import com.game.web.model.Qna;
import com.game.web.model.Report;


@Service("boardServidce")
public class BoardService {
	
	private static Logger logger = LoggerFactory.getLogger(BoardService.class);
	
	@Autowired
	private BoardDao boardDao;
	
	public int noticeInsert(Notice notice) throws Exception
	{
		int count = boardDao.noticeInsert(notice);
		
		return count;
	}
	
	public long noticeListCount(Notice notice)
	{
		long count = 0;
		
		try
		{
			count = boardDao.noticeListCount(notice);
		}
		catch(Exception e)
		{
			logger.error("[boardService]noticeListCount Exception", e);
		}
		
		return count;
	}
	
	public List<Notice> noticeList(Notice notice)
	{
		List<Notice> list = null;
		
		try
		{
			list = boardDao.noticeList(notice);
		}
		catch(Exception e)
		{
			logger.error("[boardService] noticeList Exception", e);
		}
		
		return list;
	}
	
	public Notice noticeSelect(long noticeSeq)
	{
		Notice notice = null;
		
		try
		{
			notice = boardDao.noticeSelect(noticeSeq);
		}
		catch(Exception e)
		{
			logger.error("[boardService] noticeDetail Exception e", e);
		}
		
		return notice;
	}
	
	public int noticeUpdate(Notice notice) throws Exception
	{
		int count = boardDao.noticeUpdate(notice);
		
		return count;
	}
	
	// 게시물 삭제
	public int noticeDelete(long noticeSeq) throws Exception
	{
		int count = 0;
		
		Notice notice = boardDao.noticeSelect(noticeSeq);
		
		if(notice != null)
		{
			count = boardDao.noticeDelete(noticeSeq); 
		}
		return count;
	}
	
	public long qnaListCount(Qna qna)
	{
		long count = 0;
		
		try
		{
			count = boardDao.qnaListCount(qna);
		}
		catch(Exception e)
		{
			logger.error("[boardService] qnaListCount Exception", e);
		}
		
		return count;
	}
	
	public List<Qna> qnaList(Qna qna)
	{
		List<Qna> list = null;
		
		try
		{
			list = boardDao.qnaList(qna);
		}
		catch(Exception e)
		{
			logger.error("[boardService] qnaList Exception", e);
		}
		
		return list;
	}
		
	public int qnaInsert(Qna qna) throws Exception
	{
		int count = boardDao.qnaInsert(qna);
		
		return count;
	}
	
	// 문의 조회
	public Qna qnaSelect(long qnaSeq)
	{
		Qna qna = null;
		
		try
		{
			qna = boardDao.qnaSelect(qnaSeq);
		}
		catch(Exception e)
		{
			logger.error("[boardService] qnaSelect Exception e", e);
		}
		return qna;
	}
	
	// 문의 답변 조회
	public Qna qnaReplySelect(long qnaSeq)
	{
		Qna qna = null;
		
		try
		{
			qna = boardDao.qnaReplySelect(qnaSeq);
		}
		catch(Exception e)
		{
			logger.error("[boardService] qnaReplySelect Exception e", e);
		}
		return qna;
	}
	
	// 문의 처리상태 업데이트
	public Qna qnaStatusUpdate(long qnaSeq)
	{
		Qna qna = null;
		
		try
		{
			qna = boardDao.qnaStatusUpdate(qnaSeq);
		}
		catch(Exception e)
		{
			logger.error("[boardService] qnaStatusUpdate Exception e", e);
		}
		
		return qna;
	}
	
	// 문의 답변 등록
	public int qnaReplyInsert(Qna qna) throws Exception
	{
		int count = boardDao.qnaReplyInsert(qna);
		
		return count;
	}
	
	public int qnaUpdate(Qna qna) throws Exception
	{
		int count = boardDao.qnaUpdate(qna);
		
		return count;
	}
	
	// 게시물 삭제시 답변글 수 조회
	public int qnaAnswersCount(long qnaSeq)
	{
		int count = 0;
		
		try
		{
			count = boardDao.qnaAnswerCount(qnaSeq);
		}
		catch(Exception e)
		{
			logger.error("[boardService] qnaAnswerCount Exception e", e);
		}
		
		return count;
	}
	
	// 게시물 삭제
	public int qnaDelete(long qnaSeq) throws Exception
	{
		int count = 0;
		
		Qna qna = boardDao.qnaSelect(qnaSeq);
		
		if(qna != null)
		{
			count = boardDao.qnaDelete(qnaSeq); 
		}
		return count;
	}
	
	// 신고 리스트 카운트
	public long reportListCount(Report report)
	{
		long count = 0;
		
		try
		{
			count = boardDao.reportListCount(report);
		}
		catch(Exception e)
		{
			logger.error("[boardService] reportListCount Exception", e);
		}
		return count;
	}
	
	public List<Report> reportList(Report report)
	{
		List<Report> list = null;
		
		try
		{
			list = boardDao.reportList(report);
		}
		catch(Exception e)
		{
			logger.error("[boardService] reportList Exception", e);
		}
		
		return list;
	}
	
	public Report reportSelect(long reportSeq)
	{
		Report report = null;
		
		try
		{
			report = boardDao.reportSelect(reportSeq);
		}
		catch(Exception e)
		{
			logger.error("[boardService] reportSelect Exception e", e);
		}
		return report;
	}
	
	public int reportStatusUpdate(Report report) throws Exception
	{
		int count = boardDao.reportStatusUpdate(report);
		
		return count;
	}
	
	public int reportInsert(Report report) throws Exception
	{
		int count = boardDao.reportInsert(report);
		
		return count;
	}
}
