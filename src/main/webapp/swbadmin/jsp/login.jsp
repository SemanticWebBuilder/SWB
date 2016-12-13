<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.*,org.semanticwb.platform.*,org.semanticwb.portal.*,org.semanticwb.model.*,java.util.*,org.semanticwb.base.util.*"%>
<%!
    public String getLocaleString(String key, String lang)
    {
        return SWBUtils.TEXT.getLocaleString("locale_swb_admin", key, new Locale(lang));
    }
%>
<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
    User user=SWBContext.getSessionUser();
    String lang="es";
    if(user!=null)lang=user.getLanguage();
    String username=request.getParameter("wb_username");
    String password=request.getParameter("wb_password");
    boolean error=false;
    if(username!=null)
    {
        try {
        SWBPortal.getUserMgr().login(request, response, SWBContext.getAdminWebSite());

        out.println("<script type=\"text/javascript\">");
        out.println("hideDialog();");
        out.println("</script>");
        return;
        } catch (Exception notLoged){
            error=true;
        }
    }
%>
    <form id="login_form" dojoType="dijit.form.Form" class="swbform" action="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swbadmin/jsp/login.jsp"  onsubmit="submitForm('login_form');return false;" method="post">
	<fieldset>
      <table >
        <tr >
          <td align="right">
            <label for="lang"><%=getLocaleString("user",lang)%> &nbsp;</label>
          </td>
          <td ><input type="text" name="wb_username" dojoType="dijit.form.ValidationTextBox" required="true" promptMessage="<%=getLocaleString("enter",lang)%> <%=getLocaleString("user",lang)%>." invalidMessage="<%=getLocaleString("user",lang)%> <%=getLocaleString("invalid",lang)%>." trim="true"/></td>
        </tr>
        <tr >
          <td align="right">
            <label for="lang"><%=getLocaleString("password",lang)%> &nbsp;</label>
          </td>
          <td ><input type="password" name="wb_password" dojoType="dijit.form.ValidationTextBox" promptMessage="<%=getLocaleString("enter",lang)%> <%=getLocaleString("password",lang)%>." invalidMessage="<%=getLocaleString("password",lang)%> <%=getLocaleString("invalid",lang)%>." trim="true"/></td>
        </tr>
        <tr>
          <td align="center" colspan="2">
             <button dojoType='dijit.form.Button' type="submit"><%=getLocaleString("accept",lang)%></button>
             <button dojoType='dijit.form.Button' onclick="dijit.byId('swbDialog').hide();"><%=getLocaleString("cancel",lang)%></button>
          </td>
        </tr>
      </table>
	</fieldset>
    </form>
    <div class="swbError"><%
    if(error)
    {
        out.println(getLocaleString("loginerror",lang));
    }
%></div>