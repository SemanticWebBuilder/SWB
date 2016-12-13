<%@page contentType="text/html"%><%@page pageEncoding="UTF-8"%><%@page import="org.semanticwb.*,org.semanticwb.model.*,org.semanticwb.platform.*,org.semanticwb.portal.*,java.util.*,org.semanticwb.base.util.*,com.hp.hpl.jena.ontology.*,com.hp.hpl.jena.rdf.model.*"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");

    User user = SWBContext.getAdminUser();
    if (user == null)
    {
        response.sendError(403);
        return;
    }
    String lang = user.getLanguage();
    String contx = SWBPortal.getContextPath();
    String userRep = request.getParameter("userRep");
    String users[] = request.getParameterValues("users");
    String search = request.getParameter("s");
    
    String path=paramRequest.getRenderUrl().setCallMethod(3).toString();
    
    if(search!=null)
    {
        if (userRep != null)
        {
            search=search.toLowerCase();
            Iterator<User> it2 = UserRepository.ClassMgr.getUserRepository(userRep).listUsers();
            while (it2.hasNext())
            {
                User ur = it2.next();
                String txt=ur.getLogin()+" ("+ur.getFullName()+")";
                if(search.length()==0 || txt.toLowerCase().indexOf(search)>-1)
                {
                    out.println("<option value=\""+ur.getId()+"\">"+txt+"</option>");
                }
            }
        }
        return;
    }

    if (users == null)
    {
%>

<style type="text/css">
    #uf_select, #uf_select2 {
        width:255px;
        height:300px;
        overflow:auto;
    }
    div#uf_sel1, div#uf_sel2 {
        float: left;
    }
    div#uf_leftRightButtons {
        float: left;
        padding: 10em 0.5em 0 0.5em;
    }
</style>

<form id="userFilter_form" dojoType="dijit.form.Form" class="swbform" action="<%=path%>"  onsubmit="submitForm('userFilter_form');
        return false;" method="post">
    <fieldset>
        <table>
            <tr>
                <td width="200px" align="right"><label for="userRep">Repositorio de Usuarios:</label></td>
                <td>
                    <select id="uf_userRep" name="userRep" dojoType="dijit.form.FilteringSelect" onchange_="submitForm('userFilter_form')" autoComplete="true" invalidMessage="Dato invalido." value="<%=userRep%>" >
                        <%
                            Iterator<UserRepository> it = SWBContext.listUserRepositories();
                            while (it.hasNext())
                            {
                                UserRepository ur = it.next();
                                String selected = "";
                                if (ur.getId().equals(userRep))
                                {
                                    selected = "selected=\"selected\"";
                                }
                        %>
                        <option value="<%=ur.getId()%>" <%=selected%>><%=ur.getDisplayTitle(lang)%></option>
                        <%
                            }
                        %>                        
                    </select>
                </td>
            </tr>
            <tr>
                <td width="200px" align="right"><label for="userRep">Buscador de Usuarios:</label></td>
                <td>
                    <input id="uf_search" type="text" dojoType="dijit.form.TextBox"> &nbsp; 
                    <button onclick="
                            var s=document.getElementById('uf_search').value;
                            var rep=dijit.byId('uf_userRep').value;                            
                            var cont=getSyncHtml('<%=path%>?userRep='+rep+'&s='+s);
                            var sel = document.getElementById('uf_select');
                            sel.innerHTML =cont;
                            return false;
                            " title="Buscar Usuarios">Buscar</button>
                </td>
            </tr>            
            <tr>
                <td width="200px" align="right">
                    <label>Usuarios:</label>
                </td>                
                <td> 
                    <div>
                        <div id="uf_sel1" role="presentation">
                            <label for="allusers">Lista de Usuarios:</label><br>
                            <select multiple="true" dojoType="dijit.form.MultiSelect" id="uf_select">                                
                            </select>
                        </div>
                        <div id="uf_leftRightButtons" role="presentation">
                            <span>
                                <button class="switch"  onclick="console.log(dijit.byId('uf_select'));dijit.byId('uf_select').addSelected(dijit.byId('uf_select2'));return false;" title="Move Items to First list">&lt;</button>
                                <button class="switch"  onclick="dijit.byId('uf_select2').addSelected(dijit.byId('uf_select'));return false;" title="Move Items to Second list">&gt;</button>
                            </span>
                        </div>
                        <div id="uf_sel2" role="presentation">
                            <label for="users">Usuarios seleccionados:</label><br>
                            <select multiple="true" name="users" dojoType="dijit.form.MultiSelect" id="uf_select2">
                            </select>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
    </fieldset>
    <fieldset>
        <span align="center">
            <button dojoType="dijit.form.Button" name="save" type="submit" value="save">Editar Filtro</button>
        </span>
    </fieldset>
</form>
<%
    } else //Update
    {
        String maps = "";
        Iterator<WebSite> it = SWBContext.listWebSites();
        while (it.hasNext())
        {
            WebSite webSite = it.next();
            if (webSite.getUserRepository().equals(userRep))
            {
                maps += "|" + webSite.getId();
            }
        }
        String id=SWBUtils.TEXT.join("|", users);
        //System.out.println("id:"+id);

        UserRepository rep=UserRepository.ClassMgr.getUserRepository(userRep);
        
        out.println("<form id=\"userFilter_form\" dojoType=\"dijit.form.Form\" action=\""+path+"\" class=\"swbform\" onsubmit=\"submitForm('userFilter_form');return false;\">");
        out.println("<fieldset>");
        out.println("<legend>Usuarios seleccionados</legend>");
        out.println("<ul>");
        for(int x=0;x<users.length;x++)
        {
            User usr=rep.getUser(users[x]);
            out.println(usr.getLogin()+" ("+usr.getFullName()+")");
            if(x+1<users.length)out.println(", ");
        }
        out.println("</ul>");
        out.println("</fieldset>");
        out.println("<fieldset>");
        out.println("<legend>Filtro a aplicar</legend>");
        
%>
<div class="applet">
    <applet id="editfilter" name="editfilter" code="applets.filterSection.FilterSection.class" codebase="/" archive="swbadmin/lib/SWBAplFilterSection.jar, swbadmin/lib/SWBAplCommons.jar" width="100%" height="500">
        <param name="jsess" value="<%=request.getSession().getId()%>">
        <param name="cgipath" value="/es/SWBAdmin/bh_userSectionFilter/_rid/121/_mto/3/_mod/gateway">
        <param name="locale" value="<%=lang%>">
        <param name="tm" value="<%=userRep%>">
        <param name="idresource" value="mv:<%=id%>">
        <param name="maps" value="<%=maps%>">
        <param name="isGlobalTM" value="true">
    </applet>
</div>
<%
        out.println("</fieldset>");
        
        out.println("<fieldset>");
        out.println("    <span>");
        out.println("        <button dojoType=\"dijit.form.Button\" name=\"back\" type=\"submit\" value=\"back\">Regresar</button>");
        out.println("    </span>");
        out.println("</fieldset>");   
        
        out.println("</form>");
    }
%>
