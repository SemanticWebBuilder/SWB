<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="java.util.*,java.io.PrintWriter,java.text.*,org.semanticwb.model.*,org.semanticwb.platform.*,org.semanticwb.portal.resources.projectdriver.*,org.semanticwb.portal.api.*,org.semanticwb.portal.SWBFormMgr,org.semanticwb.portal.SWBFormButton,java.util.Calendar" %>
<%
    Iterator it;
    WebPage wp=paramRequest.getWebPage();
    User user=paramRequest.getUser();
    Project wpPro = (Project)wp;
    ProjectDriverTools tool = new ProjectDriverTools();
    
%>
    <script type="text/javascript" src="/swbadmin/jsp/projectDriver/projectdriver.js"></script>
    <link href="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swbadmin/jsp/projectDriver/projectdriver.css" rel="stylesheet" type="text/css" />
<div id="proyecto">
      <div class="datosProyGral">
          <div class="datosProyIzqGral"><label for="<%=wpPro.swbproy_leader.getName()%>"><%=wpPro.swbproy_leader.getDisplayName(user.getLanguage())%> </label></div>
          <%=wpPro.getLeader()!=null?wpPro.getLeader().getFullName():paramRequest.getLocaleString("msgUnassigned")%>
      </div>
<%
   if((tool.hasChild(wp,user)))
   {
       HashMap container = tool.calculateArrayPages(paramRequest.getWebPage().listVisibleChilds(paramRequest.getUser().getLanguage()));
       ArrayList actPageCon=(ArrayList)container.get("actPageCon");
       ArrayList webPage=(ArrayList)container.get("webPage");
       ArrayList proPage=(ArrayList)container.get("proPage");
       ArrayList usPageCon=(ArrayList)container.get("usPageCon");
       if(actPageCon==null)actPageCon=new ArrayList();
       if(webPage==null)webPage=new ArrayList();
       if(proPage==null)proPage=new ArrayList();
       if(usPageCon==null)usPageCon = new ArrayList();
       String[] avances = tool.calculateProgressProject(wp, user, paramRequest.getLocaleString("msgNoProgress"), paramRequest.getLocaleString("msgTotalHours"));
       String avan = avances[0];
       String val = avances[1];
       long projectdays2 =Long.parseLong(avances[2]);
       long useddays=Long.parseLong(avances[3]);
                  %>
      <div class="datosProy">
          <div class="avanceProy">
              <div class="avanIzq"><%=paramRequest.getLocaleString("labelRealProgress")%>:</div>
              <div class="avanDer"><%=avan%>
              </div>
          </div>
          <div class="avanceProy">
              <div class="avanIzq"><%=paramRequest.getLocaleString("labelExpectedProgress")%>:</div>
              <div class="avanDer"><%=val%>
              </div>
          </div>
          <div class="fechas">
              <div class="columnasDer">
                  <div class="columDer">
                    <div class="tag"><%=paramRequest.getLocaleString("labelStartDate")%>:</div>
                    <div class="value"><%=wpPro.getStartDatep()!=null?wpPro.getStartDatep().toString().substring(8, 10)+"/" + wpPro.getStartDatep().toString().substring(5, 7)+"/"+wpPro.getStartDatep().toString().substring(0, 4):paramRequest.getLocaleString("msgUnassigned")%></div>
                  </div>
                  <div class="columIzq">
                      <div class="tag"><%=paramRequest.getLocaleString("labelEndDate")%>:</div>
                      <div class="value"><%=wpPro.getEndDatep()!=null?wpPro.getEndDatep().toString().substring(8, 10)+"/" + wpPro.getEndDatep().toString().substring(5, 7)+"/"+wpPro.getEndDatep().toString().substring(0, 4):paramRequest.getLocaleString("msgUnassigned")%></div>
                  </div>
              </div>
              <div class="columnasIzq">
                  <div class="columDer">
                      <div class="tag"><%=paramRequest.getLocaleString("labelDaysRemaining")%>:</div>
                      <div class="value"><%= projectdays2 %></div>
                  </div>
                  <div class="columIzq">
                      <div class="tag"><%=paramRequest.getLocaleString("labelElapsedDays")%>: </div>
                      <div class="value"><%= useddays==-1?0:useddays%></div>
                  </div>
              </div>
          </div>
      </div>
<%
          if(!proPage.isEmpty()){%>            <br>
<%
           out.println(tool.printPage(proPage,paramRequest.getLocaleString("titleSubproject"),user,true,paramRequest.getLocaleString("msgTotalHours")));
          }
          if(!actPageCon.isEmpty())
          {%>            <br>
<%
              it=actPageCon.iterator();
              while(it.hasNext()){
                WebPage tp=(WebPage)it.next();
                Iterator<Activity> ita = Activity.ClassMgr.listActivityByParent(tp,tp.getWebSite());
                ArrayList ChildVisible=new ArrayList();
                while(ita.hasNext())
                {
                    Activity wp1=(Activity)ita.next();
                     if(wp1.isVisible()&&tool.parentActive(wp1)&&wp1.isChildof(wp)&&wp1.isActive()&&wp1!=null&&!wp1.isHidden()&&wp1.isValid()&&!wp1.isDeleted())
                        ChildVisible.add(wp1);
                }
                it=ChildVisible.iterator();
                if(it.hasNext()){%>
                    <h2><a href="<%=tp.getUrl()%>"><%=paramRequest.getLocaleString("titleListActivities")%></a></h2>
                    <br>
                  <%while(it.hasNext())
                    {
                        WebPage wpA = (WebPage)it.next();%>
                        <div class="liespa">
                            <div class="indentation"><a href="<%=wpA.getUrl()%>"><%=wpA.getDisplayName()%></a></div>
                            <div class="espa"><%=tool.getProgressBar(tool.getListLeafActivities(wpA,user),paramRequest.getLocaleString("msgTotalHours"))%></div>
                        </div>
                    <%}
                }
              }
          }
          if(!usPageCon.isEmpty()){%>            <br>
<%            
              it=usPageCon.iterator();
              while(it.hasNext()){
                WebPage tp = (WebPage)it.next();
                ArrayList listUser=tool.getUserValid(tp);
                HashMap users = tool.getMapUsers(listUser, wp, user);
                 Iterator<UserWebPage> itU = listUser.iterator();
                if(itU.hasNext()){%>
                    <h2><a href="<%=tp.getUrl()%>"><%=paramRequest.getLocaleString("titleAssociatedPersonnel")%></a></h2>
                <%out.println(tool.viewListUsers(users, itU, paramRequest.getLocaleString("msgTotalHours"), paramRequest.getLocaleString("msgNoProgress")));
                }
              }
          }
          if(!webPage.isEmpty()){%>            <br>
<%
           out.println(tool.printPage(webPage,paramRequest.getLocaleString("titleSections"),user,false,paramRequest.getLocaleString("msgTotalHours")));
         }
   }
%><br>
</div>
