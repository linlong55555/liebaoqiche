package com.ibest.recon.controller;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ibest.framework.common.enums.EnumsRtnMapResult;
import com.ibest.framework.common.persistence.BaseController;
import com.ibest.framework.common.utils.PageList;
import com.ibest.framework.common.utils.UserUtils;
import com.ibest.framework.system.entity.SysUser;
import com.ibest.pay.entity.OutSystemOrder;
import com.ibest.pay.entity.PayInfo;
import com.ibest.pay.service.OutSystemOrderService;
import com.ibest.pay.service.PayInfoService;
import com.ibest.recon.dto.input.OutSystemLocalReconInputDTO;
import com.ibest.recon.entity.OutSystemLocalRecon;
import com.ibest.recon.service.OutSystemLocalReconService;

@Controller
@RequestMapping(value="${adminPath}/recon/outSystemLocalRecon")
public class OutSystemLocalReconController extends BaseController {
	
	private static final Logger logger = LoggerFactory.getLogger(OutSystemLocalReconController.class);
	
	@Autowired
	private OutSystemLocalReconService outSystemLocalReconService;
	
	@Autowired
	private OutSystemOrderService outSystemOrderService;
	
	@Autowired
	private PayInfoService payInfoService;
	
	
	/**
	* 进入到列表页
	*/
	@RequestMapping(value="/")
	public String index(){
		return "module/recon/outSystemLocalRecon/outSystemLocalReconList";
	}
	
	/**
	* 进入到表单页-创建
	*/
	@RequestMapping(value="/add")
	public String add(){
		
		return "module/recon/outSystemLocalRecon/outSystemLocalReconForm";
	}
	
	/**
	* 进入到表单页，编辑
	*/
	@RequestMapping(value="/edit")
	public String edit(@RequestParam String id, Model model){
		try {
			if(StringUtils.isNotEmpty(id)){
				OutSystemLocalRecon outSystemLocalRecon = outSystemLocalReconService.findById(id);
				if(outSystemLocalRecon != null){
					model.addAttribute("outSystemLocalRecon", outSystemLocalRecon);
				}else{
					setRtnCodeAndMsg(EnumsRtnMapResult.FAILURE.getCode(), "您查看的信息不存在！", model);
				}
			}else{
				setRtnCodeAndMsg(EnumsRtnMapResult.FAILURE.getCode(), "请选择需要编辑的信息！", model);
			}
		} catch (Exception e) {
			setRtnCodeAndMsg(EnumsRtnMapResult.EXCEPTION.getCode(), EnumsRtnMapResult.EXCEPTION.getMsg(), model);
		}
		return "module/recon/outSystemLocalRecon/outSystemLocalReconForm";
	}
	
	/**
	* 进入到详情页
	*/
	@RequestMapping(value="/view")
	public String view(@RequestParam String id, Model model){
		try {
			if(StringUtils.isNotEmpty(id)){
				OutSystemLocalRecon outSystemLocalRecon = outSystemLocalReconService.findById(id);
				if(outSystemLocalRecon != null){
					model.addAttribute("outSystemLocalRecon", outSystemLocalRecon);
				}else{
					setRtnCodeAndMsg(EnumsRtnMapResult.FAILURE.getCode(), "您查看的信息不存在！", model);
				}
			}else{
				setRtnCodeAndMsg(EnumsRtnMapResult.FAILURE.getCode(), "请选择需要查看的信息！", model);
			}
		} catch (Exception e) {
			setRtnCodeAndMsg(EnumsRtnMapResult.EXCEPTION.getCode(), EnumsRtnMapResult.EXCEPTION.getMsg(), model);
		}
		return "module/recon/outSystemLocalRecon/outSystemLocalReconDetail";
	}

	/**
	* 异步分页查询
	*/
	@ResponseBody
	@RequiresPermissions("outSystemLocalRecon:query")
	@RequestMapping(value="/list")
	public PageList<OutSystemLocalRecon> list(OutSystemLocalReconInputDTO outSystemLocalRecon, HttpServletRequest request){
		
		PageList<OutSystemLocalRecon> pageList = new PageList<OutSystemLocalRecon>();
		
		try {
			//设置分页参数
			super.setPage(request, pageList);
		
			pageList = outSystemLocalReconService.findByPage(pageList, outSystemLocalRecon);
			List<OutSystemLocalRecon> osList = pageList.getRows();
			List<OutSystemLocalRecon> list = new ArrayList<OutSystemLocalRecon>();
			if(osList!=null && osList.size()>0) {
				for (OutSystemLocalRecon info : osList) {
					if(info.getBillType().equals("00")) {
						info.setBillType("支付");
					}else {
						info.setBillType("退款");
					}
					if(info.getTradeState()!=null) {
						if(info.getTradeState().equals("00")) {
							info.setTradeState("支付成功");
						}else if(info.getTradeState().equals("01")) {
							info.setTradeState("失败");
						}else if(info.getTradeState().equals("02")) {
							info.setTradeState("未知错误请查询交易状态");
						}else if(info.getTradeState().equals("03")) {
							info.setTradeState("申请退款中");
						}else if(info.getTradeState().equals("04")) {
							info.setTradeState("未支付");
						}else if(info.getTradeState().equals("09")) {
							info.setTradeState("已退款");
						}else if(info.getTradeState().equals("08")) {
							info.setTradeState("全额退款，交易关闭");
						}
					}
					
					if(info.getBillType()!=null) {
						if(info.getReconState().equals("00")) {
							info.setReconState("成功");
						}else if(info.getReconState().equals("01")) {
							info.setReconState("订单状态不一致");
						}else if(info.getReconState().equals("02")) {
							info.setReconState("订单金额不一致");
						}
					}
					info.setTradeAmount(changeF2Y(info.getTradeAmount())+"元");
					list.add(info);
				}
			}
			pageList.setRows(list);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return pageList;
	}
	
	/**
	* 异步表单提交
	*/
	@ResponseBody
	@RequiresPermissions("outSystemLocalRecon:create")
	@RequestMapping(value="create")
	public Map<String, Object> insert(OutSystemLocalRecon outSystemLocalRecon){

		Map<String, Object> rtnMap = new HashMap<String, Object>();
		setRtnCodeAndMsgBySuccess(rtnMap, "保存成功");
		
		try {
			int result = outSystemLocalReconService.insert(outSystemLocalRecon);
			if(result == 0){
				setRtnCodeAndMsgByFailure(rtnMap, "保存失败");
			}
		} catch (Exception e) {
			e.printStackTrace();
			setRtnCodeAndMsgByException(rtnMap, null);
		}
		return rtnMap;
	}
	
	@ResponseBody
	@RequiresPermissions("outSystemLocalRecon:update")
	@RequestMapping(value="update")
	public Map<String, Object> update(OutSystemLocalRecon outSystemLocalRecon){

		Map<String, Object> rtnMap = new HashMap<String, Object>();
		setRtnCodeAndMsgBySuccess(rtnMap, "保存成功");
		
		try {
			int result = outSystemLocalReconService.update(outSystemLocalRecon);
			if(result == 0){
				setRtnCodeAndMsgByFailure(rtnMap, "保存失败");
			}
		} catch (Exception e) {
			e.printStackTrace();
			setRtnCodeAndMsgByException(rtnMap, null);
		}
		return rtnMap;
	}
	
	@ResponseBody
	@RequiresPermissions("outSystemLocalRecon:delete")
	@RequestMapping(value="delete")
	public Map<String, Object> delete(@RequestParam(required=true) String ids){
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		setRtnCodeAndMsgBySuccess(rtnMap, "删除成功");
		
		try {
			int result = outSystemLocalReconService.deleteByIds(ids);
			if(result == 0){
				setRtnCodeAndMsgByFailure(rtnMap, "删除失败");
			}
		} catch (Exception e) {
			e.printStackTrace();
			setRtnCodeAndMsgByException(rtnMap, null);
		}
		return rtnMap;
	}
	
	/**
	 * 对账
	 * @Title: recon  
	 * @param: @param reconChannel
	 * @param: @param billType
	 * @param: @param billDate
	 * @return:Map<String,Object>
	 * @author: WeiJia
	 * @date:2018年4月24日 下午7:09:31
	 */
	@ResponseBody
	@RequiresPermissions("outSystemLocalRecon:recon")
	@RequestMapping(value="recon")
	public Map<String, Object> recon(String billDate){
		Map<String, Object>  rtnMap = new HashMap<String, Object>();
		try {
			List<OutSystemOrder> outSystemList = outSystemOrderService.findByOrderPayTime(billDate);
			List<PayInfo> payInfoList = payInfoService.findByOrderSendTime(billDate);
			
			SysUser user = UserUtils.getCurrentUser();
			if((outSystemList!=null && outSystemList.size()>0) && (payInfoList!=null && payInfoList.size()>0) ) {
				for (PayInfo payInfo : payInfoList) {
					for (OutSystemOrder os : outSystemList) {
						OutSystemLocalRecon sl = new OutSystemLocalRecon();
						if(payInfo.getOrderId().equals(os.getOrderId())) {//订单号相同
							if(!payInfo.getOrderStatus().equals(os.getOrderStatus())) {//状态是否一致
								sl.setBillType("00");
								sl.setOrderId(os.getOrderId());
								sl.setRenconTime(billDate);
								sl.setTradeAmount(payInfo.getAmount());
								sl.setTradeTime(os.getOrderPayTime());
								sl.setTradeType(payInfo.getPayType());
								sl.setTradeState(payInfo.getOrderStatus());
								sl.setReconState("01");
								sl.setFailMessage("接入系统订单状态，与本地系统订单状态不一致");
								sl.setCreater(user.getUsername());
								sl.setCreateTime(new Date());
								sl.setModifier(user.getUsername());
								sl.setModifyTime(new Date());
								outSystemLocalReconService.insert(sl);
							}
							
							if(!payInfo.getAmount().equals(os.getAmount())) {//金额是否一致
								sl.setBillType("00");
								sl.setOrderId(os.getOrderId());
								sl.setRenconTime(billDate);
								sl.setTradeAmount(payInfo.getAmount());
								sl.setTradeTime(os.getOrderPayTime());
								sl.setTradeType(payInfo.getPayType());
								sl.setTradeState(payInfo.getOrderStatus());
								sl.setReconState("02");
								sl.setFailMessage("接入系统订单金额，与本地系统订单金额不一致");
								sl.setCreater(user.getUsername());
								sl.setCreateTime(new Date());
								sl.setModifier(user.getUsername());
								sl.setModifyTime(new Date());
								outSystemLocalReconService.insert(sl);
							}
						}
					}
				}
				setRtnCodeAndMsgByFailure(rtnMap, "操作成功");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return rtnMap;
	}
	
	/**
	 * 分转元
	 * @Title: changeF2Y  
	 * @param: @param amount
	 * @param: @throws Exception
	 * @date:2018年4月27日 上午9:30:16
	 */
	public static String changeF2Y(String amount) throws Exception{    
        return BigDecimal.valueOf(Long.valueOf(amount)).divide(new BigDecimal(100)).toString();    
    }   
}
