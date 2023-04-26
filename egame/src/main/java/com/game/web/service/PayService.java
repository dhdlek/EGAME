package com.game.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.game.web.dao.PayDao;
import com.game.web.model.Pay;
import com.game.web.model.UserPoint;

@Service("payService")
public class PayService
{	
	private static Logger logger = LoggerFactory.getLogger(PayService.class);
	
	@Autowired
	private PayDao payDao;
	
	//결제 인서트
	public int payInsert(Pay pay)
	{
		int count = 0;
		
		try
		{
			count = payDao.payInsert(pay);
		}
		catch(Exception e)
		{
			logger.error("[PayService] payInsert Exception", e);
		}
		
		return count;
	}
	
	//보유게임 수
	public long libraryCount(String userId)
	{
		long libraryCount = 0;
		
		try
		{
			libraryCount = payDao.libraryCount(userId);
		}
		catch(Exception e)
		{
			logger.error("[PayService] libraryCount Exception", e);
		}
		
		return libraryCount;
	}
	
	//보유게임 리스트
	public List<Pay> libraryList(Pay pay)
	{
		List<Pay> list = null;
		
		try
		{
			list = payDao.libraryList(pay);
		}
		catch(Exception e)
		{
			logger.error("[PayService] libraryList Exception", e);
		}
		
		return list;
	}
	
	//친구 마이페이지 보유게임 전체목록 조회
	public List<Pay> libraryAllList(Pay pay) 
	{		
		List<Pay> list = null;
		
		try
		{
			list = payDao.libraryAllList(pay);  
		}
		catch(Exception e)
		{
			logger.error("[PayService] libraryAllList Exception", e);
		}
		
		return list;
	}
	
	//보유게임 조회
	public Pay librarySelect(long paySeq)
	{
		Pay pay = null;
		
		try
		{
			pay = payDao.librarySelect(paySeq);
		}
		catch(Exception e)
		{
			logger.error("[PayService] librarySelect", e);
		}
		
		return pay;
	}
	
	//보유게임 환불
	public int libraryRefund(Pay pay)
	{
		int count = 0;
		
		try
		{
			count = payDao.libraryRefund(pay);
		}
		catch(Exception e)
		{
			logger.error("[PayService] libraryRefund Exception", e);
		}
		
		return count;
	}
	
	//포인트 인서트
	public int userPointInsert(UserPoint userPoint)
	{
		int count = 0;
		
		try
		{
			count = payDao.userPointInsert(userPoint);
		}
		catch(Exception e)
		{
			logger.error("[PayService] userPointInsert Exception", e);
		}
		
		return count;
	}
	
	//포인트내역 수
	public long pointCount(String userId)
	{
		long pointCount = 0;
		
		try
		{
			pointCount = payDao.pointCount(userId);
		}
		catch(Exception e)
		{
			logger.error("[PayService] pointCount Exception", e);
		}
		
		return pointCount;
	}
	
	//포인트내역 리스트
	public List<UserPoint> pointList(UserPoint userPoint)
	{
		List<UserPoint> list = null;
		
		try
		{
			list = payDao.pointList(userPoint);
		}
		catch(Exception e)
		{
			logger.error("[PayService] pointList Exception", e);
		}
		
		return list;
	}
	
	//포인트내역 조회
	public UserPoint pointSelect(long pointSeq)
	{
		UserPoint userPoint = null;
		
		try
		{
			userPoint = payDao.pointSelect(pointSeq);
		}
		catch(Exception e)
		{
			logger.error("[PayService] pointSelect", e);
		}
		
		return userPoint;
	}
}
