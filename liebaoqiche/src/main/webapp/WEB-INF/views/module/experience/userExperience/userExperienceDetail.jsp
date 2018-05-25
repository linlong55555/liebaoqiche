<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE>
<html>
<head>
	<title>UserExperience</title>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/loading.jsp"%>
	<div class="easyui-layout" data-options="fit:true">
		<div data-options="region:'center'">
    		<table style="width: 100%;">
    			<tbody>
    				<tr>
    					<td style="width: 50%; padding: 5px;">
    						id
    					</td>
    					<td style="width: 50%; padding: 5px;">
    						${userExperience.id}
    					</td>
    				</tr>
    				<tr>
    					<td style="width: 50%; padding: 5px;">
    						user_id
    					</td>
    					<td style="width: 50%; padding: 5px;">
    						${userExperience.userId}
    					</td>
    				</tr>
    				<tr>
    					<td style="width: 50%; padding: 5px;">
    						vin_no
    					</td>
    					<td style="width: 50%; padding: 5px;">
    						${userExperience.vinNo}
    					</td>
    				</tr>
    				<tr>
    					<td style="width: 50%; padding: 5px;">
    						experience_id
    					</td>
    					<td style="width: 50%; padding: 5px;">
    						${userExperience.experienceId}
    					</td>
    				</tr>
    				<tr>
    					<td style="width: 50%; padding: 5px;">
    						activity_system_id
    					</td>
    					<td style="width: 50%; padding: 5px;">
    						${userExperience.activitySystemId}
    					</td>
    				</tr>
    				<tr>
    					<td style="width: 50%; padding: 5px;">
    						app_id
    					</td>
    					<td style="width: 50%; padding: 5px;">
    						${userExperience.appId}
    					</td>
    				</tr>
    				<tr>
    					<td style="width: 50%; padding: 5px;">
    						创建人
    					</td>
    					<td style="width: 50%; padding: 5px;">
    						${userExperience.creater}
    					</td>
    				</tr>
    				<tr>
    					<td style="width: 50%; padding: 5px;">
    						创建时间
    					</td>
    					<td style="width: 50%; padding: 5px;">
    						${userExperience.createTime}
    					</td>
    				</tr>
    				<tr>
    					<td style="width: 50%; padding: 5px;">
    						修改人
    					</td>
    					<td style="width: 50%; padding: 5px;">
    						${userExperience.modifier}
    					</td>
    				</tr>
    				<tr>
    					<td style="width: 50%; padding: 5px;">
    						修改时间
    					</td>
    					<td style="width: 50%; padding: 5px;">
    						${userExperience.modifyTime}
    					</td>
    				</tr>
    				<tr>
    					<td style="width: 50%; padding: 5px;">
    						版本
    					</td>
    					<td style="width: 50%; padding: 5px;">
    						${userExperience.version}
    					</td>
    				</tr>
    				<tr>
    					<td style="width: 50%; padding: 5px;">
    						备注
    					</td>
    					<td style="width: 50%; padding: 5px;">
    						${userExperience.remarks}
    					</td>
    				</tr>
    				<tr>
    					<td style="width: 50%; padding: 5px;">
    						<label class="label-top">备注:</label>
    						<input class="easyui-textbox" name="remarks" style="width:99.5%; height:80px;" data-options="multiline:true">
    					</td>
    				</tr>
    			</tbody>
    		</table>
		</div>
		<div data-options="region:'south',border:false" style="text-align:right; padding:10px;">
            <a id="btnCancel_UserExperience" href="javascript:void(0)" class="easyui-linkbutton button-warning" style="width: 80px;"><i class="fa fa-remove fa-lg"></i>&nbsp;&nbsp;取消</a>
        </div>
   	</div>
    
    <!-- js脚本，必须写在body中，tab的url加载模式只会异步加载body中的内容到tab中 -->
	<script type="text/javascript">
		require(['jquery','common'], function($){
			// 给保存按钮添加点击事件
			$("#btnCancel_UserExperience").on('click', function(){
				history.go(-1);
			});
		});
	</script>
</body>
</html>