<%--
    Document   : view
    Created on : 04-ago-2016, 16:25:14
    Author     : hasdai
--%>
<%@page import="org.semanticwb.model.Role"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.semanticwb.model.UserRepository"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.model.SWBContext"%>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="java.io.File"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.model.PFlow"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
PFlow af = (PFlow) SWBPlatform.getSemanticMgr().getOntology().getGenericObject(request.getParameter("suri"));
String resID = af.getWebSite().getId()+"_"+af.getId();

SWBResourceURL data = paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setMode("gateway").setAction("getWorkflow");
data.setParameter("suri", request.getParameter("suri"));

SWBResourceURL save = paramRequest.getActionUrl().setAction("updateWorkflow");
save.setParameter("suri", request.getParameter("suri"));
save.setParameter("id", resID);

User user = SWBContext.getAdminUser();
String pathAct = "/swbadmin/jsp/SWBAWorkflow/activity.jsp";
String pathTrans = "/swbadmin/jsp/SWBAWorkflow/transition.jsp";

if (SWBContext.getAdminWebSite().equals(paramRequest.getWebPage().getWebSite()) && null != user) {
    %>
    <script>require(['dijit/Dialog', 'dijit/registry', 'dijit/form/Select']);</script>
    <link href="<%= SWBPlatform.getContextPath() %>/swbadmin/js/dojo/dojox/grid/enhanced/resources/EnhancedGrid.css" rel="stylesheet" />
    <link href="<%= SWBPlatform.getContextPath() %>/swbadmin/js/dojo/dojox/grid/resources/soriaGrid.css" rel="stylesheet" />
    <link href="<%= SWBPlatform.getContextPath() %>/swbadmin/css/fontawesome/font-awesome.css" rel="stylesheet" />
    <style>
        .soria .dojoxGridRowOver .dojoxGridCell {
            background-color: none !important;
            color: black !important;
        }

        .activityTable {
            width: 100%;
        }

        .activityTable th {
            width:20%;
            padding: 5px;
        }

        .activityTable th.actions {
            width:10% !important;
        }

        .activityTable th.steps {
            width:5% !important;
        }

        .activityTable tbody tr:nth-child(even) {
           background-color: #E1EBFB;
        }

        rect.docActivity {
            -webkit-user-select: none; /* webkit (safari, chrome) browsers */
            -moz-user-select: none; /* mozilla browsers */
            -khtml-user-select: none; /* webkit (konqueror) browsers */
            -ms-user-select: none; /* IE10+ */
        }

        div.svgContainer {
            width: 100%;
        }

        div.svgContainer svg {
            width: 1280px;
        }

        svg text {
            -webkit-user-select: none;
               -moz-user-select: none;
                -ms-user-select: none;
                    user-select: none;
        }
        svg text::selection {
            background: none;
        }
    </style>
    <jsp:include page="<%= pathAct %>" />
    <jsp:include page="<%= pathTrans %>" />
    <div id="container_<%= resID %>" data-dojo-type="dijit/layout/BorderContainer" data-dojo-props="gutters:true, liveSplitters:false">
        <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'top', splitter:false">
            <button id="saveButton_<%= resID %>" type="button"></button>
            <button id="addActivity_<%= resID %>" type="button"></button>
            <button id="addSequence_<%= resID %>" type="button">Agregar secuencia</button>
            <div style="float: right;"><b><%= paramRequest.getLocaleString("lblFlowVersion") %>:</b><span id="filterVersion_<%= resID %>"></span></div>
        </div>
        <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'center', splitter:false">
            <div id="mainPanel_<%= resID %>" data-dojo-type="dijit/layout/TabContainer" style="width: 100%; height:100%;">
                <div data-dojo-type="dijit/layout/ContentPane" title="<%= paramRequest.getLocaleString("lblRTypesTab") %>" data-dojo-props="selected:true">
                    <div id="resourceTypes_<%= resID %>"></div>
                </div>
                <div data-dojo-type="dijit/layout/ContentPane" title="<%= paramRequest.getLocaleString("lblDesignTab") %>">
                    <div data-dojo-type="dijit/layout/BorderContainer" data-dojo-props="gutters:true, liveSplitters:false">
                        <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'top', splitter:false">
                            <div id="svgContainer_<%= resID %>" class="svgContainer">
                                <svg></svg>
                            </div>
                        </div>
                        <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'center', splitter:false">
                            <table class="activityTable">
                                <thead>
                                    <tr>
                                        <th class="steps">Paso</th>
                                        <th class="actions"></th>
                                        <th>Actividad</th>
                                        <th>Descripción</th>
                                        <th>Usuarios</th>
                                        <th>Roles</th>
                                    </tr>
                                </thead>
                                <tbody id="activities_<%= resID %>"></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <script type="dojo/method" src="<%= SWBPlatform.getContextPath() %>/swbadmin/jsp/SWBAWorkflow/workflow.js"></script>
                <script type="dojo/method">
                    require({packages: [
                            {
                                name: "d3",
                                location: "<%= SWBPlatform.getContextPath() %>/swbadmin/js/d3/",
                                main: "d3"
                            },
                            {
                                name: "workflow",
                                location: "<%= SWBPlatform.getContextPath() %>/swbadmin/jsp/SWBAWorkflow/",
                                main: "workflow"
                            }
                            ]},
                        ['d3','workflow',
                        'dojo/domReady!', 'dojo/dom', 'dojo/request/xhr',
                        'dojox/widget/Standby', 'dijit/registry',
                        'dijit/form/CheckBox', 'dojo/dom-construct',
                        'dojox/grid/enhanced/plugins/IndirectSelection'],
                    function(d3, workflowApp, ready, dom, xhr, StandBy, registry, CheckBox, domConstruct) {
                        var standby = new StandBy({target: "container_<%= resID %>"});

                        document.body.appendChild(standby.domNode);
                        standby.startup();
                        standby.show();

                        //Create users and roles data for grids
                        <%
                        String usrdata = "[]";
                        UserRepository adminRep = SWBContext.getAdminRepository();
                        Iterator<User> adminUsers = adminRep.listUsers();
                        if (adminUsers.hasNext()) {
                            usrdata =  "[";
                            while (adminUsers.hasNext()) {
                                User usr = adminUsers.next();
                                usrdata+="{\"id\":\""+usr.getId()+"\",";
                                usrdata+="\"name\":\""+usr.getLogin()+"\"}";
                                if (adminUsers.hasNext()) usrdata+=",";
                            }
                            usrdata += "]";
                        }

                        String roledata = "[]";
                        Iterator<Role> adminRoles = adminRep.listRoles();
                        if (adminRoles.hasNext()) {
                            roledata =  "[";
                            while (adminRoles.hasNext()) {
                                Role role = adminRoles.next();
                                roledata+="{\"id\":\""+role.getId()+"\",";
                                roledata+="\"name\":\""+role.getTitle()+"\",";
                                roledata+="\"repository\":\""+role.getUserRepository().getId()+"\"}";
                                if (adminRoles.hasNext()) roledata+=",";
                            }
                            roledata += "]";
                        }
                        %>
                        var usrData_<%= resID %> = <%= usrdata %>;
                        var roleData_<%= resID %> = <%= roledata %>;

                        xhr("<%= data %>", {
                            handleAs: "json"
                        }).then(function(_data) {
                            _data.users = usrData_<%= resID %>;
                            _data.roles = roleData_<%= resID %>;
                            workflowApp.initUI("<%= resID %>", _data, "es", '<%= save %>');
                        }, function(err) {
                            alert("<%= paramRequest.getLocaleString("msgError") %>");
                        });
                        standby.hide();
                    });
                </script>
            </div>
        </div>
    </div>
    <%
    }
%>
