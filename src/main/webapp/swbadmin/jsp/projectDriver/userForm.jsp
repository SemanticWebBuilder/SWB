<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="java.util.*,java.text.*,org.semanticwb.portal.resources.projectdriver.*,java.io.PrintWriter,org.semanticwb.model.*,org.semanticwb.platform.*,org.semanticwb.portal.api.*,org.semanticwb.portal.SWBFormMgr,org.semanticwb.portal.SWBFormButton" %>
<%
        User user=paramRequest.getUser();
        UserWebPage userwp = (UserWebPage)paramRequest.getWebPage();
        Iterator<UserWebPage> it = UserWebPage.ClassMgr.listUserWebPageByParent(userwp, userwp.getWebSite());
        SWBResourceURL url=paramRequest.getActionUrl();
        String speciality = paramRequest.getLocaleString("msgUnassigned");
        if(userwp.getSpeciality()!=null)
            speciality = userwp.getSpeciality();
        boolean uservalid = false;
        if(userwp.getURI()!=null && user.getURI()!=null && userwp.getUserWP()!=null){
           if(user.getURI().equals(userwp.getUserWP().getURI()))
               uservalid = true;
        }
        ProjectDriverTools tool = new ProjectDriverTools();
%>
        <script type="text/javascript" src="/swbadmin/jsp/projectDriver/projectdriver.js"></script>
        <link href="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swbadmin/jsp/projectDriver/projectdriver.css" rel="stylesheet" type="text/css" />
<div id="proyecto">
<%
    if(!it.hasNext()){
        HashMap contByStatus = tool.actsByStatus(userwp, user);
        
        ArrayList assig=(ArrayList)contByStatus.get("assigned");
        ArrayList canc=(ArrayList)contByStatus.get("canceled");
        ArrayList devel=(ArrayList)contByStatus.get("develop");
        ArrayList paus=(ArrayList)contByStatus.get("paused");
        ArrayList end =(ArrayList)contByStatus.get("ended");
        ArrayList listAct = (ArrayList)contByStatus.get("list");
       
        if(listAct==null) listAct = new ArrayList();
        if(assig==null) assig = new ArrayList();
        if(canc==null) canc = new ArrayList();
        if(devel == null)devel = new ArrayList();
        if(paus==null)paus=new ArrayList();
        if(end==null)end=new ArrayList();
        String avanTot=tool.getProgressBar(listAct,paramRequest.getLocaleString("msgTotalHours"));
        if(avanTot==null)
          avanTot=paramRequest.getLocaleString("msgNoProgress");
        url.setAction("upduser");
        url.setParameter("uri", userwp.getURI());
        %>
                    <form id="frmUser" name="frmUser" action="<%=url.toString()%>" method ="post">
                        <div class="datosUsuario">
                            <div class="datosUsuIzq"><label for="<%=userwp.swbproy_userWP.getName()%>"><%=userwp.swbproy_userWP.getDisplayName(user.getLanguage())%> </label></div>
                            <div class="datosUsuDer"><%=userwp.getUserWP()!=null?userwp.getUserWP().getFullName():paramRequest.getLocaleString("msgUnassigned")%></div>
                            <div class="datosUsuIzq"><label for="<%=userwp.swbproy_speciality.getName()%>"><%=userwp.swbproy_speciality.getDisplayName(user.getLanguage())%> </label></div>
                            <%if(uservalid){
                            %><div class="datosUsuDer"><input id="<%=userwp.swbproy_speciality.getName()%>" name="<%=userwp.swbproy_speciality.getName()%>" value="<%=userwp.getSpeciality()!=null?userwp.getSpeciality():""%>" style="width:200px" ></div><%}else{%>
                            <div class="datosUsuDer"><%=speciality%></div><%}%>
                        </div>
                        <div class="avanceUsuario">
                            <div class="datosUsuIzq"><%=paramRequest.getLocaleString("labelTotalProgress")%>:</div>
                            <div class="datosUsuDer"> <%=avanTot%></div>
                        </div>
                    </form>
        <%
        if(!assig.isEmpty()){
        %>
        <h3><%=paramRequest.getLocaleString("titleNoBeginActivities")%></h3><br>
        <%out.println(tool.printStatusActivity(assig,paramRequest.getLocaleString("msgTotalHours")));
        }
        if(!devel.isEmpty()){
        %>
        <h3><%=paramRequest.getLocaleString("titleDevelopmentActivities")%></h3><br>
        <%out.println(tool.printStatusActivity(devel,paramRequest.getLocaleString("msgTotalHours")));
        }
        if(!paus.isEmpty()){
        %>
        <h3><%=paramRequest.getLocaleString("titleInterruptedActivities")%></h3><br>
        <%out.println(tool.printStatusActivity(paus,paramRequest.getLocaleString("msgTotalHours")));
        }
        if(!canc.isEmpty()){
        %>
        <h3><%=paramRequest.getLocaleString("titleCanceledActivities")%></h3><br>
        <%out.println(tool.printStatusActivity(canc,paramRequest.getLocaleString("msgTotalHours")));
        }
        if(!end.isEmpty()){
        %>
        <h3><%=paramRequest.getLocaleString("titleCompletedActivities")%></h3><br>
        <%out.println(tool.printStatusActivity(end,paramRequest.getLocaleString("msgTotalHours")));
        }
   }else{%>
                    <form id="frmUser" name="frmUser" action="<%=url.toString()%>" method ="post">
                        <div class="datosUsuario">
                            <div class="datosUsuIzq"><label for="<%=userwp.swbproy_userWP.getName()%>"><%=userwp.swbproy_userWP.getDisplayName(user.getLanguage())%> </label></div>
                            <div class="datosUsuDer"><%=userwp.getUserWP()!=null?userwp.getUserWP().getFullName():paramRequest.getLocaleString("msgUnassigned")%></div>
                            <div class="datosUsuIzq"><label for="<%=userwp.swbproy_speciality.getName()%>"><%=userwp.swbproy_speciality.getDisplayName(user.getLanguage())%> </label></div>
                            <%if(uservalid){
                            %><div class="datosUsuDer"><input id="<%=userwp.swbproy_speciality.getName()%>" name="<%=userwp.swbproy_speciality.getName()%>" value="<%=userwp.getSpeciality()!=null?userwp.getSpeciality():""%>" style="width:200px" ></div><%}else{%>
                            <div class="datosUsuDer"><%=speciality%></div>
                            <div class="datosUsuIzq"><%=paramRequest.getLocaleString("labelTotalProgress")%>:</div>
                            <div class="datosUsuDer"><%=paramRequest.getLocaleString("msgNoProgress")%>Sin Avance</div><%}%>
                        </div>
                    </form>
<%  }%>
</div>
