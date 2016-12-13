<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="java.util.*,org.semanticwb.portal.SWBFormMgr,java.io.PrintWriter,java.text.*,org.semanticwb.model.*,org.semanticwb.platform.*,org.semanticwb.portal.resources.projectdriver.*,org.semanticwb.portal.api.*,org.semanticwb.portal.*,java.sql.Timestamp"%>
<%
            ArrayList proBar=new ArrayList();
            WebPage wp=paramRequest.getWebPage();
            User user=paramRequest.getUser();
            ProjectDriverTools tool = new ProjectDriverTools();
            WebPage parent=tool.getProject(wp);
            Iterator it=wp.listVisibleChilds(user.getLanguage());
            Activity act = (Activity)wp;
            tool.validAct(act);
            proBar.add(act.getCurrentPercentage());
            proBar.add(act.getPlannedHour());
            boolean editAct = false;
            if(user.getURI()!=null&&act.getResponsible()!=null){
                if(user.getURI().equals(act.getResponsible().getURI())){
                    editAct = true;
                }
            }
            
            ArrayList mess = new ArrayList();
            mess.add(paramRequest.getLocaleString("msgAddPlannedh"));
            mess.add(paramRequest.getLocaleString("msgAddCurrenth"));
            mess.add(paramRequest.getLocaleString("msgAddPercentagep"));
            mess.add(paramRequest.getLocaleString("msgAddnumericPlannedh"));
            mess.add(paramRequest.getLocaleString("msgAddnumericCurrenth"));
            mess.add(paramRequest.getLocaleString("msgAddnumericCurrentp"));
            mess.add(paramRequest.getLocaleString("msgAddvaluepositive"));
%>
 <script type="text/javascript" src="/swbadmin/jsp/projectDriver/projectdriver.js"></script>
 <link href="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swbadmin/jsp/projectDriver/projectdriver.css" rel="stylesheet" type="text/css" />
<div id="proyecto">
<%
          if(it.hasNext())
          {
              HashMap container = tool.calculateArrayPages(it);
              ArrayList webpage = (ArrayList)container.get("webPage");
    %>
         <div class="datos">
            <div class="global">
                <div class="etiquetas"><%=paramRequest.getLocaleString("titleProject")%>: </div>
                <div class="elementos"><%=parent.getDisplayName()%></div>
            </div>
            <div class="globalA">
                <div class="etiquetas"><%=paramRequest.getLocaleString("labelActivityProgress")%>: </div>
                <div class="barraDatos"><%=tool.getProgressBar(tool.getListLeafActivities(act,user),paramRequest.getLocaleString("msgTotalHours"))%>
                </div>
            </div>
         </div>
      <%
          out.println(tool.getWebPageListLevel(act,user,3,paramRequest.getLocaleString("titleSubactivities"),"",paramRequest.getLocaleString("msgTotalHours")));
          if(!webpage.isEmpty())
            out.println(tool.printPage(webpage,paramRequest.getLocaleString("titleSections"),user,false,""));
          }else{
            ArrayList labels = tool.getLabelStatus(act,user);
            if(editAct){
              SWBFormMgr mgr = new SWBFormMgr(act.getSemanticObject(),null,SWBFormMgr.MODE_EDIT);
              mgr.setLang(user.getLanguage());
              mgr.setType(mgr.TYPE_XHTML);
              SWBResourceURL url=paramRequest.getActionUrl();
              url.setParameter("uri", act.getURI());
              url.setAction("update");
              mgr.addHiddenParameter(Activity.swb_active.getName(), Boolean.toString(act.isActive()));
              boolean checkPrede=tool.checkPredecesor(act);%>
        <fieldset><legend><%=paramRequest.getLocaleString("labelMonitoring")%></legend>
        <form id="<%=act.getURI()+"/form"%>" name="<%=act.getURI()+"/form"%>" class="edit" action="<%=url.toString()%>" method="post">
           
            <input type="hidden" name="status_ini" value="<%=act.getStatus()%>">
            <table class="detail">
              <tbody>
              <tr><td width="200px"><%=mgr.renderLabel(request,act.swbproy_critical,mgr.MODE_EDIT)%></td>
                  <td><%
                  if(act.getStatus().equals("canceled")||act.getStatus().equals("ended")){String checked="";
                      if(act.isCritical()){checked="checked=\"checked\"";}
                      out.println("<input type=\"checkbox\" id=\""+act.swbproy_critical.getName()+"\" name=\""+act.swbproy_critical.getName()+"\""+checked+"\" disabled=\"disabled\">");
                  }else
                       out.println(mgr.renderElement(request, act.swbproy_critical,mgr.MODE_EDIT));
    %>             </td>
              </tr>
              <tr><td width="200px"><%=mgr.renderLabel(request, act.swbproy_actType, mgr.MODE_EDIT)%></td>
                  <td><%
                  if(act.getStatus().equals("canceled")||act.getStatus().equals("ended")){
                     String value=act.getActType();
                     if(value==null)value="";
                     out.println("<input id=\""+act.swbproy_actType.getName()+"\" name=\""+act.swbproy_actType.getName()+"\" value=\""+value+"\" style=\"width:300px\" disabled=\"disabled\">");
                  }else
                   out.println(mgr.renderElement(request, act.swbproy_actType,mgr.MODE_EDIT));
    %>             </td>
              </tr>
              <tr><td width="200px"><%=mgr.renderLabel(request, act.swbproy_status, mgr.MODE_EDIT)%></td><td><select name="<%=Activity.swbproy_status.getName()%>"<%if(checkPrede){%>disabled<%}%>>
                     <%boolean un,as,ca,de,pa,en; un=as=ca=de=pa=en=false;
                        String value1=act.getStatus().toString();
                        if(value1.equals("unassigned")) un=ca=as=true;
                        else if(value1.equals("assigned")) as=de=ca=true;
                        else if(value1.equals("develop")) de=pa=en=ca=true;
                        else if(value1.equals("paused")) pa=de=ca=true;
                        else if(value1.equals("ended")) en=true;
                        else if(value1.equals("canceled"))ca=true;
                        it = labels.iterator();
                        while(it.hasNext()){
                            String as1 = it.next().toString();
                            String s = it.next().toString();
                            boolean s1 = Boolean.parseBoolean(it.next().toString());
                            if(as1.equals("unassigned")&&un){
                            %><option value="<%=as1%>"<%
                            if (s1){%>selected<%}%>><%=s%></option><%
                            }else if(as1.equals("assigned")&&as){
                            %><option value="<%=as1%>"<%
                            if (s1){%>selected<%}%>><%=s%></option><%
                            }else if(as1.equals("canceled")&&ca){
                            %><option value="<%=as1%>"<%
                            if (s1){%>selected<%}%>><%=s%></option><%
                            }else if(as1.equals("develop")&&de){
                            %><option value="<%=as1%>"<%
                            if (s1){%>selected<%}%>><%=s%></option><%
                            }else if(as1.equals("paused")&&pa){
                            %><option value="<%=as1%>"<%
                            if (s1){%>selected<%}%>><%=s%></option><%
                            }else if(as1.equals("ended")&&en){
                            %><option value="<%=as1%>"<%
                            if (s1){%>selected<%}%>><%=s%></option><%
                            }
                        }
                %></select></td>
              </tr>
              <tr><td width="200px"><%=mgr.renderLabel(request, act.swbproy_hasPredecessor, mgr.MODE_EDIT)%></td>
                  <td><%
                   ArrayList vals1=tool.getActsPrede(act,user);
                   ArrayList listAll=tool.getActsForPrec(act, parent);
                   it = listAll.iterator();
                   %><select name="<%=act.swbproy_hasPredecessor.getName()%>" multiple="true" size="4" style="width:300px;" <%if(act.getStatus().equals("canceled")||act.getStatus().equals("ended")){%>disabled<%}%>><%
                   if(it.hasNext())%><option value=""><%
                   while (it.hasNext()){
                        WebPage sob = (WebPage)it.next();
                        if (!sob.isParentof(act) &&sob.getURI() != null) {
                            %><option value="<%=sob.getURI()%>"<%
                            if (vals1.contains(sob.getURI())) {
                                %>selected="selected"<%}
                            %>><%=sob.getDisplayName(user.getLanguage())%></option><%}
                   }%></select>
                  </td>
              </tr>
              <tr><td width="200px"><%=mgr.renderLabel(request, act.swbproy_responsible, mgr.MODE_EDIT)%></td>
                  <td><%
                  %><select name="<%=act.swbproy_responsible.getName()%>" disabled><%
                  SemanticObject uri=null;
                  if(act.getResponsible()!=null)
                    uri = SemanticObject.createSemanticObject(act.getResponsible().getURI());
                  if (uri!=null) {
                  %><option value="<%=uri.getURI()%>" selected><%=uri.getDisplayName(user.getLanguage())%></option><%
                  }else
                  %><option value=" " selected> </option>
                  </select>
                 </td>
              </tr>
              <tr><td width="200px"><%=mgr.renderLabel(request, act.swbproy_hasParticipants, mgr.MODE_EDIT)%></td>
                  <td><%
                    ArrayList<String> vals=new ArrayList();
                    it=act.listParticipantses();
                    while(it.hasNext())
                        vals.add(it.next().toString());
                    ArrayList responsible = tool.listUserRepository(act.getWebSite());
                    it = responsible.iterator();
                  %><select name="<%=act.swbproy_hasParticipants.getName()%>" multiple="true"  size="4" style="width:300px;"<%
                    if(act.getStatus().equals("canceled")||act.getStatus().equals("ended")){
                            %>disabled<%
                    }%>><%if(it.hasNext())%><option value=""><%
                    while (it.hasNext()) {
                        SemanticObject sob = SemanticObject.createSemanticObject(it.next().toString());
                        if (sob.getURI() != null&&sob.getURI()!=act.getResponsible().getURI()) {
                            %><option value="<%=sob.getURI()%>"<%
                            if (vals.contains(sob.getURI())) {
                                %>selected="selected"<%}
                            %>><%=sob.getDisplayName(user.getLanguage())%></option><%}
                    }%></select><%
    %>               </td>
              </tr>
              <tr>
                  <td width="200px"><%=mgr.renderLabel(request, act.swb_created, mgr.MODE_VIEW)%></td>
                  <td><%=mgr.renderElement(request, act.swb_created,mgr.MODE_VIEW)%></td>
              </tr><%         if(act.getStatus().equals("develop")||act.getStatus().equals("ended")||act.getStatus().equals("canceled")||act.getStatus().equals("paused")){%>
               <tr><td width="200px"><%=mgr.renderLabel(request, act.swbproy_startDate, mgr.MODE_VIEW)%></td>
                   <td><%=mgr.renderElement(request, act.swbproy_startDate,mgr.MODE_VIEW)%></td>
               </tr>
    <%         }%>
    <%         if(act.getStatus().equals("ended")||act.getStatus().equals("canceled")){%>
               <tr><td width="200px"><%=mgr.renderLabel(request, act.swbproy_endDate, mgr.MODE_VIEW)%></td>
                   <td><%=mgr.renderElement(request, act.swbproy_endDate,mgr.MODE_VIEW)%></td>
               </tr>
    <%         }%>
              <tr><td width="200px"><%=mgr.renderLabel(request, act.swbproy_plannedHour, mgr.MODE_EDIT)%></td>
                  <td><%
                  if(act.getStatus().equals("canceled")||act.getStatus().equals("ended"))
                     out.println("<input id=\""+act.swbproy_plannedHour.getName()+"\" name=\""+act.swbproy_plannedHour.getName()+"\" value=\""+act.getPlannedHour()+"\" style=\"width:300px\" disabled=\"disabled\">");
                  else
                     out.println("<input id=\""+act.swbproy_plannedHour.getName()+"\" name=\""+act.swbproy_plannedHour.getName()+"\" value=\""+act.getPlannedHour()+"\" style=\"width:300px\" dojoType=\"dijit.form.ValidationTextBox\" regExp=\"\\d+\" invalidMessage=\""+paramRequest.getLocaleString("msgOnlyIntegers")+"\">");
    %>             </td>
              </tr>
              <tr><td width="200px"><%=mgr.renderLabel(request, act.swbproy_currentHour, mgr.MODE_EDIT)%></td>
                  <td><%
                  if(act.getStatus().equals("canceled")||act.getStatus().equals("ended")||checkPrede)
                     out.println("<input id=\""+act.swbproy_currentHour.getName()+"\" name=\""+act.swbproy_currentHour.getName()+"\" value=\""+act.getCurrentHour()+"\" style=\"width:300px\" disabled=\"disabled\">");
                  else
                    out.println("<input id=\""+act.swbproy_currentHour.getName()+"\" name=\""+act.swbproy_currentHour.getName()+"\" value=\""+act.getCurrentHour()+"\" style=\"width:300px\" dojoType=\"dijit.form.ValidationTextBox\" regExp=\"\\d+\" invalidMessage=\""+paramRequest.getLocaleString("msgOnlyIntegers")+"\">");
    %>             </td>
              </tr>
              <tr><td width="200px"><%=mgr.renderLabel(request, act.swbproy_currentPercentage, mgr.MODE_EDIT)%></td>
                  <td><%String form="\\d+([.])\\d+";
                  if(act.getStatus().equals("canceled")||act.getStatus().equals("ended")||checkPrede)
                     out.println("<input id=\""+act.swbproy_currentPercentage.getName()+"\" name=\""+act.swbproy_currentPercentage.getName()+"\" value=\""+act.getCurrentPercentage()+"\" style=\"width:300px\" disabled=\"disabled\">");
                  else
                     out.println("<input id=\""+act.swbproy_currentPercentage.getName()+"\" name=\""+act.swbproy_currentPercentage.getName()+"\" value=\""+act.getCurrentPercentage()+"\" style=\"width:300px\" dojoType=\"dijit.form.ValidationTextBox\" regExp=\""+form+"\" invalidMessage=\""+paramRequest.getLocaleString("msgOnlyfloatingn")+"\">");

        %>              </td>
              </tr>
            </tbody>
           </table>
              <div class="barraGeneral"><%=tool.getProgressBar(proBar,paramRequest.getLocaleString("msgTotalHours"))%></div>
               <% if(!act.getStatus().equals("canceled")&&!act.getStatus().equals("ended")){%><div class="botones"><div class="btnIzq"><%
                    out.println("<button type=\"button\" onclick=\"calcular(this.form)\">"+paramRequest.getLocaleString("btnCalculate")+"</button>");%></div><div class="btnDer"><%
                    out.println("<button type=\"submit\" onclick=\"return validar(this.form,'"+mess+"')\">"+paramRequest.getLocaleString("btnUpdate")+"</button>");%></div></div><%
                   }
                %>
           </form>
        </fieldset>
    <%      }else{
              SWBFormMgr mgr = new SWBFormMgr(act.getSemanticObject(), null, SWBFormMgr.MODE_VIEW);
              mgr.setLang(user.getLanguage());
              mgr.setType(mgr.TYPE_XHTML);
    %>
        <fieldset><legend><%=paramRequest.getLocaleString("labelActivityDetail")%></legend>
            <br><label><%=paramRequest.getLocaleString("labelActivityProgress")%>:</label><br>
          <div class="barraGeneral">
          <%=tool.getProgressBar(proBar,paramRequest.getLocaleString("msgTotalHours"))%>
          </div>
          <br>
          <table  class="detail">
            <tbody>
                <tr><td width="150"><label for="proyect"><%=paramRequest.getLocaleString("titleProject")%> </label></td>
                   <td><%=parent.getDisplayName()%></td>
               </tr>
               <tr><td><%=mgr.renderLabel(request, act.swbproy_actType, mgr.MODE_VIEW)%></td><%
                  if(act.getActType().equals("")){%>
                  <td><%=paramRequest.getLocaleString("msgUnassigned")%></td>
                  <%}else{%>
                  <td><%=mgr.renderElement(request, act.swbproy_actType,mgr.MODE_VIEW)%></td>
                  <%}
                   %>
               </tr>
               <tr><td><%=mgr.renderLabel(request,act.swbproy_critical,mgr.MODE_VIEW)%></td>
                   <td><%=mgr.renderElement(request, act.swbproy_critical,mgr.MODE_VIEW)%></td>
               </tr>
               <tr><td><%=mgr.renderLabel(request, act.swbproy_hasPredecessor, mgr.MODE_VIEW)%></td>
                   <td>
                    <%GenericIterator <Activity> it1 = act.listPredecessors();
                    if(it1.hasNext()){%>
                     <select name="<%=act.swbproy_hasPredecessor.getName()%>"  size="3" multiple="true" style="width:200px;">
                      <%while(it1.hasNext()){
                       Activity act1=it1.next();%>
                       <option value="<%=act1.getDisplayName()%>"><%=act1.getDisplayName()%></option>
                      <%}%>
                     </select>
                    <%}
                    else
                       out.println(paramRequest.getLocaleString("msgNoPredecessors"));%>
                   </td>
               </tr>
               <tr><td><%=mgr.renderLabel(request, act.swbproy_status, mgr.MODE_VIEW)%></td><%
                    String label = act.getStatus()!=null?act.getStatus():paramRequest.getLocaleString("msgUnassigned");
                    it = labels.iterator();
                    String value = paramRequest.getLocaleString("msgUnassigned");
                    while(it.hasNext()){
                        String aitz1 = it.next().toString();
                        if(aitz1.equals(label))
                           value = it.next().toString();
                    }
                    %>
                   <td><%=value%></td>
               </tr>
               <tr><td><%=mgr.renderLabel(request, act.swbproy_responsible, mgr.MODE_VIEW)%></td>
                   <td>
                     <%if(act.getResponsible()!=null){%>
                        <%=act.getResponsible().getFullName()%>
                     <%}else{
                       out.println(paramRequest.getLocaleString("msgUnassigned"));}%>
                   </td>
               </tr>
               <tr><td><%=mgr.renderLabel(request, act.swbproy_hasParticipants, mgr.MODE_VIEW)%></td>
                   <td>
                    <%GenericIterator<User> it2 = act.listParticipantses();
                    if(it2.hasNext()){%>
                     <select name="<%=act.swbproy_hasParticipants.getName()%>"  size="2" multiple="true" style="width:200px;">
                      <%while(it2.hasNext()){
                        User us=it2.next();%>
                        <option value="<%=us.getFullName()%>"><%=us.getFullName()%></option>
                      <%}%>
                     </select>
                    <%}
                    else{
                     out.println(paramRequest.getLocaleString("msgNoParticipants"));}%>
                   </td>
               </tr>
               <tr><td><%=mgr.renderLabel(request, act.swbproy_plannedHour, mgr.MODE_VIEW)%></td>
                   <td><%=mgr.renderElement(request, act.swbproy_plannedHour.getName(),mgr.MODE_VIEW)%></td>
               </tr>
               <tr><td><%=mgr.renderLabel(request, act.swbproy_currentHour, mgr.MODE_VIEW)%></td>
                   <td><%=mgr.renderElement(request, act.swbproy_currentHour,mgr.MODE_VIEW)%></td>
               </tr>
               <tr><td><%=mgr.renderLabel(request, act.swbproy_currentPercentage, mgr.MODE_VIEW)%></td>
                   <td><%=mgr.renderElement(request,act.swbproy_currentPercentage,mgr.MODE_VIEW)%></td>
               </tr>
               <tr><td><%=mgr.renderLabel(request, act.swb_created, mgr.MODE_VIEW)%></td>
                   <td><%=mgr.renderElement(request, act.swb_created,mgr.MODE_VIEW)%></td>
               </tr>
    <%         if(act.getStatus().equals("develop")||act.getStatus().equals("ended")||act.getStatus().equals("canceled")||act.getStatus().equals("paused")){%>
               <tr><td><%=mgr.renderLabel(request, act.swbproy_startDate, mgr.MODE_VIEW)%></td>
                   <td><%=mgr.renderElement(request, act.swbproy_startDate,mgr.MODE_VIEW)%></td>
               </tr>
    <%         }%>
    <%         if(act.getStatus().equals("ended")||act.getStatus().equals("canceled")){%>
               <tr><td><%=mgr.renderLabel(request, act.swbproy_endDate, mgr.MODE_VIEW)%></td>
                   <td><%=mgr.renderElement(request, act.swbproy_endDate,mgr.MODE_VIEW)%></td>
               </tr>
    <%         }%>
            </tbody>
          </table>
        </fieldset>
    <%      }
          }%>
</div>
