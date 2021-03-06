<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE>
<html>
<head>
	<title>Integral</title>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
	<style>
		.switch{
			width:44px;
			height:22px;
			/* border:1px solid #264dbe; */
			border-radius:22px;
			overflow:hidden;
		}
		.switch>div{
			position:relative;
			width:100%;
			height:100%;
			background:#ccc;
		}
		.switch>div>b{
			position:absolute;
			top:1px;
			left:1px;
			diplay:block;
			width:20px;
			height:20px;
			background:#fff;
			border-radius:20px;
		}
		.switch.active>div{
			background:#264dbe;
		}
		.switch.active>div>b{
			left:23px;
		}
	</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/loading.jsp"%>
	<!-- 数据列表  -->
	<div class="easyui-layout" data-options="fit:true,border:false">
		<div data-options="region:'center'">
			<table id="Grid" class="easyui-datagrid" title="" ctrlSelect="true" striped="true"
				rownumbers="true" pagination="true" fitColumns="true" toolbar="#Grid_Toolbar"
				loadMsg="正在加载数据，请稍等..." emptyMsg="没有找到符合条件的数据"
				data-options="url:'${ctx}/integral/integral/list',fit:true, fitColumns:true, checkOnSelect:true, selectOnCheck:true, border: false,onDblClickRow:onDblClickRow">
			    <thead>
			        <tr>
			            <th data-options="field:'ck',checkbox:true"></th>
			            <th data-options="field:'id',width:100,hidden:true">id</th>
			            <th data-options="field:'name',width:100">积分名称</th>
			            <th data-options="field:'integral',width:100">积分数</th>
			            <th data-options="field:'integralCategoryId',width:100,hidden:true">积分类别编号</th>
			            <th data-options="field:'integralCategoryName',width:100">积分类型</th>
			            <th data-options="field:'state',formatter:switchstate">状态</th>
			            <th data-options="field:'isDelete',width:100,hidden:true">是否删除；0未删除，1删除</th>
			        </tr>
			    </thead>
			</table>
			<div id="Grid_Toolbar">
				<div class="pull-right">
					<shiro:hasPermission name="integral:create">
				        <a id="btnCreate" href="javascript:void(0)" class="easyui-linkbutton button-success"><i class="fa fa-plus-circle fa-lg"></i>&nbsp;&nbsp;新增</a>
					</shiro:hasPermission>
					
					<shiro:hasPermission name="integral:update">
				        <a id="btnUpdate" href="javascript:void(0)" class="easyui-linkbutton button-default"><i class="fa fa-pencil fa-lg"></i>&nbsp;&nbsp;修改</a>
					</shiro:hasPermission>
					
					<shiro:hasPermission name="integral:delete">
				        <a id="btnDelete" href="javascript:void(0)" class="easyui-linkbutton button-danger"><i class="fa fa-minus-circle fa-lg"></i>&nbsp;&nbsp;删除</a>
					</shiro:hasPermission>
					
			    </div>
				<form id="searchForm" name="searchForm">
					<input class="easyui-textbox" id="name" name="name" labelWidth="70" data-options="validType:'special',validType:'special',prompt:'积分名称'">
					<input class="easyui-combobox" id="integralCategoryId" name="integralCategoryId" labelWidth="70"
					       data-options="
											        url:'${ctx}/integral/integralCategory/types',
											        textField:'categoryName',
											        valueField:'id',
											        panelHeight:'300px',
											        editable:false,
											        prompt:'积分类型'">
					<a id="btnSearch" href="javascript:void(0)" class="easyui-linkbutton button-primary"><i class="fa fa-search fa-lg"></i>&nbsp;&nbsp;查询</a>
					<a href="javascript:void(0)" class="easyui-linkbutton reset l-btn l-btn-small" plain="true" onclick="resetForm('searchForm')"><i class="fa fa-repeat fa-lg"></i>&nbsp;&nbsp;重置</a>
				</form>
		    </div>
		</div>
	</div>
	
    <!-- js脚本，必须写在body中，tab的url加载模式只会异步加载body中的内容到tab中 -->
	<script type="text/javascript">
		require(['jquery','common'], function($){
			// 给新增按钮添加点击事件
			$("#btnCreate").on('click', function(){
				showDialog('新增', '${ctx}/integral/integral/add', 800, 500, function () {
					$('#Grid').datagrid('reload');
				});
			});
			
			// 给修改按钮添加点击事件
			$("#btnUpdate").on('click', function(){
				var selected = $("#Grid").datagrid('getSelections');
				if(selected.length == 0){
					$.messager.alert('提示','请选择需要修改的记录', "info");
				}
				if(selected.length > 1){
					$.messager.alert('提示','只能选择一条需要修改的记录', "info");
				}
				if(selected.length == 1){
					if(selected[0].state == "0"){
						$.messager.alert('提示','请确认积分状态关闭后进行修改！', "info");	
					}
					else{
						showDialog('编辑', '${ctx}/integral/integral/edit?id=' + selected[0].id, 800, 500, function () {
							$('#Grid').datagrid('reload');
						});
					}
				}
			});
			
			// 给删除按钮添加点击事件
			$("#btnDelete").on('click', function(){
				var selected = $("#Grid").datagrid('getSelections');
				var flag = false;
				if(selected.length == 0){
					$.messager.alert('提示','请选择需要删除的记录', "info");
				}
				if(selected.length > 0){
					for(var i =0;i<selected.length;i++){
						if(selected[i].state == '0'){
							$.messager.alert('提示','请确认积分状态关闭后删除！', "info");
							return;
						}
					}
					flag =true;
				}
				if(flag == true){
					$.messager.confirm('警告', '确认删除本条记录吗?', function (r) {
                        if(r){
                            var ids = '';
                            for (var i = 0; i < selected.length; i++) {
                                ids += selected[i].id + ',';
                            }
                            
                            $.ajax({
	                            url: '${ctx}/integral/integral/delete',
	                            data: {
	                                ids: ids
	                            },
	                            type: 'post',
	                            dataType: 'json',
	                            success: function (json) {
	                                if (json && json.rtnCode == '00000000') {
	                                    $.messager.alert('提示', "删除成功", "success");
	                                    $('#Grid').datagrid('reload');
	                                } else {
	                                    $.messager.alert('提示', json.rtnMsg);
	                                }
	                            }
                        	});
						}
                    });
				}
			});

			// 给查询按钮添加点击事件
			$("#btnSearch").on('click', function(){
				if($('#searchForm').form('enableValidation').form('validate')){
					reload();
				}
			});
		});

		/**
		 * Easyui重置表单
		 * @param formId
		 */
		function resetForm(formId){
			$('#'+formId).form('clear');
			reload();
		};

		function reload(){
			var params = $('#Grid').datagrid('options').queryParams;
			params.name = $('#name').val();
			params.integralCategoryId = $('#integralCategoryId').val();
			$('#Grid').datagrid('options').queryParams = params;
			$('#Grid').datagrid('reload');
		}

		function onDblClickRow (index, row) {
			showDialog('<i class="fa fa-eye fa-lg"></i>&nbsp;&nbsp;详情页面', '/admin/integral/integral/view?id=' + row.id, 800, 500);
		}
		
		function switchstate(value,rowData,rowIndex){
			var operate = '';
			if(value == "0"){ // 0 开启
				operate = '<div class="switch active" id='+rowData.id+' onclick="switchClick(\''+value+'\',\''+rowData.id+'\',\''+rowIndex+'\',this)"><div><b></b></div></div>';
			}else{ // 1 关闭
				operate = '<div class="switch" id='+rowData.id+' onclick="switchClick(\''+value+'\',\''+rowData.id+'\',\''+rowIndex+'\',this)"><div><b></b></div></div>';
			}
			return operate;
		}
		
		function switchClick(value,id,index,e){
			var msg = (value=="0"?"关闭":"开启");
			$.messager.confirm('警告', '您确认'+msg+'吗?', function (r) {
				if(r) {
					value=(value=="0"?"1":"0");
					$.post('${ctx}/integral/integral/updateState',{id:id,state:value},function(data){
						if(data.rtnCode == '00000000'){//修改成功
							$("#Grid").datagrid("updateRow",{  
                                index:index, //行索引  
                                row:{  
                                	state:value //行中的某个字段  
                                }  
                            });  
							if(value == "0"){
								$("#"+id).addClass("active");
							}else{
								$("#"+id).removeClass("active");
							}
						}else{
							$.messager.alert('提示','当前积分与活动进行关联，不能进行关闭操作！', "info");
						}
					});
				}
			});
		}
	</script>
</body>
</html>