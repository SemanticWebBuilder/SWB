<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Iterator, org.semanticwb.portal.SWBUtilTag, org.semanticwb.portal.util.SWBIFMethod, java.util.HashMap, java.net.URLEncoder, org.semanticwb.SWBPortal, org.semanticwb.portal.api.*, org.semanticwb.model.*, org.semanticwb.SWBPlatform" %>
<%
	SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
	String ruleId = (String) request.getAttribute("ruleId");
	String ruleModel = (String) request.getAttribute("ruleModel");
	
	Rule r = null;
	if (null != ruleModel) {
		r = SWBContext.getWebSite(ruleModel).getRule(ruleId);
	}
	
	if (null == r) return;
%>
<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" href="<%= SWBPlatform.getContextPath() %>/swbadmin/css/bootstrap/bootstrap.css">
		<link rel="stylesheet" href="<%= SWBPlatform.getContextPath() %>/swbadmin/js/jquery/query-builder/css/query-builder.default.min.css">
		<style type="text/css">
			html, body {
 		   	width: 100%;
    		height: 100%;
    		margin: 0;
			}
			
			.editorContainer {
				overflow:scroll;
				height:100%;
				margin-top:40px;
				border-top:1px solid #ccc;
				padding-bottom:30px;
			}
			
			.editorRibbon {
				position: absolute;
				top:5px;
				left:5px;
				overflow:hidden;
			}
		</style>
	</head>
	<body>
		<div class="editorRibbon">
			<div class="row">
				<div class="col-sm-12">
	  			<button id="saveButton_<%= ruleModel %>_<%= ruleId %>" type="button" class="btn btn-sm btn-primary">Guardar</button>
	  		</div>
	  	</div>
		</div>
		<div class="editorContainer">
			<div id="ruleEditor_<%= ruleModel %>_<%= ruleId %>"></div>
		</div>
   	<script src="<%= SWBPlatform.getContextPath() %>/swbadmin/js/jquery/jquery.js"></script>
   	<script src="<%= SWBPlatform.getContextPath() %>/swbadmin/js/jquery/query-builder/js/query-builder.standalone.min.js"></script>
   	<script src="<%= SWBPlatform.getContextPath() %>/swbadmin/js/jquery/query-builder/plugins/not-group/plugin.js"></script>
   	<script>
   		(function($) {
   			var filterData = [];
   			
   			$('#saveButton_<%= ruleModel %>_<%= ruleId %>').on('click', function() {
				  var result = $('#ruleEditor_<%= ruleModel %>_<%= ruleId %>').queryBuilder('getRules');
				  
				  if (!$.isEmptyObject(result)) {
				  	$.ajax({
		   				url: "<%= paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setMode("updateRuleDefinition").setParameter("tm", ruleModel).setParameter("id", ruleId) %>", 
		   				method:"POST",
		   				data: JSON.stringify(result),
		   				dataType: "json",
		   				contentType: "application/json; charset=utf-8"
		   			}).done(function(data) {
		   				if (data.status && data.status === "ok") {
		   					alert("Se ha actualizado la regla correctamente");
		   				}
	   				});
				  }
				});
   			
   			
   			function getFilters(attributes) {
					attributes.sort(function(a, b) {
						if (a.title.toLowerCase() < b.title.toLowerCase()) return -1;
						if (a.title.toLowerCase() === b.title.toLowerCase()) return 0;
						if (a.title.toLowerCase() > b.title.toLowerCase()) return 1;
					});   				

   				return attributes.map(function(item) {
   					var filterDef = {};
   					filterDef.id = item.name;
   					filterDef.label = item.title;
   					
   					//Process SWBPageHistory different
   					if (item.name === "SWBWebPageHistory") {
   						filterDef.operators = ["equal", "not_equal", "history"];
   						
   						filterDef.input = function(rule, name) {
								var $opselect = rule.$el.find('.rule-operator-container select');
								var $container = rule.$el.find('.rule-value-container');
								
								$opselect.on("change", function(c) {
								
									var optype = $(this).val(); 
									if ("history" === optype) {
										var htmltxt = '<select class="form-control" name="'+ name +'">';
										for (var i=1; i<26; i++) {
 											htmltxt += '<option value="' + i + '">-'+ i +'</option>';
 										}
 										htmltxt += '</select>';
										$container.html(htmltxt);
									} else {
										$container.html('<input type="text" name="' + name + '" class="form-control" />');
									}
								});
								
								return '<input type="text" name="' + name + '" class="form-control" />';
							};
   						
   					} else {
   						if (item.operators && item.operators.length) {
		   					filterDef.operators = item.operators.map(function(operator) {
		   						if (operator.value === "=") {
		   							return "equal";
		   						} else if (operator.value === "!=") {
		   							return "not_equal";
		   						} else if (operator.value === "&gt;") {
		   							return "greater";
	   							} else if (operator.value === "&lt;") {
	   								return "less";
	   							}
		   					});
		   					
		   					item.catalog = item.catalog.filter(function(citem) {
		   						return citem.value && citem.value !== "TEXT";
		   					});
		   					
		   					if (item.catalog && item.catalog.length) {
		   						filterDef.input = "select";
		   						filterDef.values = item.catalog.map(function(option) {
										var ret = {};
		   							ret [option.value] = option.title;
		   							return ret;
		   						});
		   					}
	   					}
   					}
   					
   					return filterDef;
   				});
   			};
   		
   			$.ajax({
   				url: "<%= paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setMode("getRuleFilters") %>", 
   				method:"GET",
   				dataType: "json"
   			}).done(function(data) {
   				filterData = data && data.attributes && getFilters(data.attributes);
   				
   				$.ajax({
	   				url: "<%= paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setMode("getRuleDefinition").setParameter("suri", r.getURI()) %>", 
	   				method:"GET",
	   				dataType: "json"
	   			}).done(function(data2) {
	   				var rules = data2;
	   				if(!$.isEmptyObject(rules)) {
   						if (!rules.condition) {
		   					rules = {
		   						condition: "AND",
		   						not: false,
		   						rules: [data2]
		   					}
		   				}
   					}
   					
   					var opts = {
			   			plugins: {
					      'not-group': null
					    },
			   			operators: [
			   				{ type: 'equal'},
		  					{ type: 'not_equal'},
		  					{ type: 'less'},
		  					{ type: 'less_or_equal'},
		  					{ type: 'greater'},
		  					{ type: 'greater_or_equal'},
								{ type: 'history', nb_inputs: 1, multiple: true, apply_to: ['string'] }
			   			],
							filters: filterData,
							lang:{
								__locale: "Spanish (es)",
			  				add_rule: "Agregar regla",
			  				add_group: "Agregar grupo",
			  				delete_rule: "Eliminar",
			  				delete_group: "Eliminar",
			  				
			 					conditions: {
			    				AND: "Y",
			    				OR: "O",
									NOT: "NO"
			  				},
			
			  				operators: {
			    				equal: "igual",
			    				not_equal: "distinto de",
			    				less: "menor",
			    				less_or_equal: "menor o igual",
			    				greater: "mayor",
			    				greater_or_equal: "mayor o igual",
			    				history: "es"
			  				},
			  			
			  				errors: {
			    				no_filter: "No se ha seleccionado ningún filtro",
			    				empty_group: "El grupo está vacío",
			    				radio_empty: "Ningún valor seleccionado",
			    				checkbox_empty: "Ningún valor seleccionado",
			    				select_empty: "Ningún valor seleccionado",
			    				string_empty: "Cadena vacía",
			    				string_exceed_min_length: "Debe contener al menos {0} caracteres",
			    				string_exceed_max_length: "No debe contener más de {0} caracteres",
			    				string_invalid_format: "Formato inválido ({0})",
			    				number_nan: "No es un número",
			    				number_not_integer: "No es un número entero",
			    				number_not_double: "No es un número real",
			    				number_exceed_min: "Debe ser mayor que {0}",
			    				number_exceed_max: "Debe ser menor que {0}",
			    				number_wrong_step: "Debe ser múltiplo de {0}",
			    				datetime_invalid: "Formato de fecha inválido ({0})",
			    				datetime_exceed_min: "Debe ser posterior a {0}",
			    				datetime_exceed_max: "Debe ser anterior a {0}"
			  				}
							}
   					};
   					
   					if(!$.isEmptyObject(rules)) {
   						opts.rules = rules;
   					}
	   			
	   				$("#ruleEditor_<%= ruleModel %>_<%= ruleId %>").queryBuilder(opts);
	   				
	   			})
	   			.error(function(err){console.log(err)});
   				
   			});
   		
   		})($);
   	</script>
	</body>
</html>
