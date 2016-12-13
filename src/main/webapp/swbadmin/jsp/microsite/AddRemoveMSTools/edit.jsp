<%--
    Document   : add
    Created on : 30/08/2009, 11:38:48 AM
    Author     : juan.fernandez
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.platform.*,org.semanticwb.portal.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%
    SWBParamRequest paramRequest=(SWBParamRequest)request.getAttribute("paramRequest");
    User user=paramRequest.getUser();


    WebPage wp = paramRequest.getWebPage();
    WebSite model = wp.getWebSite();

%>
    <body>
<%

        boolean isMicrosite = false;
        Member member = null;

        if (wp instanceof MicroSite) {
            isMicrosite = true;
            member = getMember(user, (MicroSite)wp);
        }

        if (isMicrosite&&member!=null&&member.getAccessLevel()>=Member.LEVEL_ADMIN&&user.isRegistered())
        {
           if (paramRequest.getCallMethod() == SWBParamRequest.Call_STRATEGY) {
                SWBResourceURL url = paramRequest.getRenderUrl();
                url.setParameter("act", "edit");
                url.setCallMethod(SWBResourceURL.Call_CONTENT);
                url.setWindowState(SWBResourceURL.WinState_MAXIMIZED);
                %>
                <ul>
                    <li><a href="<%=url%>">Administrar Herramientas</a></li>
                </ul>
                <%
            }
            else
            {
                HashMap hmwp = new HashMap();
                Iterator<WebPage> itwp = wp.listChilds(user.getLanguage(), true, false, false, true);
                while(itwp.hasNext())
                {
                    WebPage wpc = itwp.next();
                    hmwp.put(wpc.getId(), wp);
                }

                
                
                SWBResourceURL urla = paramRequest.getActionUrl();
                urla.setParameter("act","update");
                out.println("<div id=\"admintools\">"); // antes tenía class=groupInteres
                
                out.println("<form action=\""+urla+"\" method=\"post\" name=\"frm_adminTools\">");
                out.println("<table >");


                out.println("<thead><tr><td colspan=\"2\" align=\"left\"><h2 class=\"tituloGrande\">Edición comunidad</h2></td></tr></thead>");

                out.println("<tbody>");
                out.println("<tr>");
                out.println("<td>");
                out.println("<p>Título:</p>");
                out.println("</td>");
                out.println("<td>");
                out.println("<p><input type=\"text\" name=\"title\" size=\"41\" value=\""+wp.getDisplayName(user.getLanguage())+"\"></p>");
                out.println("</td>");
                out.println("</tr>");
                out.println("<tr>");
                out.println("<td>");
                out.println("<p>Descripción:</p>");
                out.println("</td>");
                out.println("<td>");
                out.println("<p><textarea name=\"description\" rows=\"7\" cols=\"30\">"+wp.getDescription()+"</textarea></p>");
                out.println("</td>");
                out.println("</tr>");
                out.println("<tr>");

                out.println("<td>");
                out.println("<p>Palabras clave:</p>");
                out.println("</td>");
                out.println("<td>");
                out.println("<p><input type=\"text\" name=\"tags\" size=\"41\" value=\""+wp.getTags()+"\"></p>");
                out.println("</td>");
                out.println("</tr>");

                out.println("<tr><th colspan=\"2\" align=\"left\"><h2 class=\"tituloGrande\">Herramientas</h2></th></tr>");
                out.println("<tr><td colspan=\"2\"><table>");
                Iterator<MicroSiteUtil> itmsu = ((MicrositeContainer) model).listMicroSiteUtils();

                int ncol=0;
                while (itmsu.hasNext()) {
                    MicroSiteUtil msu = itmsu.next();

                    if(ncol==0)
                        out.println("<tr>");
                    ncol++;

                    String toolsel = "";
                    if(hmwp.get(wp.getId()+"_"+msu.getId())!=null) toolsel = "checked";
                    out.println("<td>");
                    out.println("<p><input type=\"checkbox\" id=\"" + msu.getId() + "\" name=\"micrositeutil\" "+toolsel+" value=\""+ msu.getURI() +"\"><label for=\"" + msu.getId() + "\">"+msu.getDisplayTitle(user.getLanguage())+"</label></p>");
                    out.println("</td>");
                    if(ncol==4)
                    {
                        ncol=0;
                        out.println("</tr>");
                    }
                }
                if(ncol>0)
                {
                   if(ncol==1) out.println("<td></td><td></td><td></td>");
                   else if(ncol==2) out.println("<td></td><td></td>");
                   else if(ncol==3) out.println("<td></td>");

                   out.println("</tr>");
                }


                out.println("</table>");
                out.println("</td>");
                out.println("</tr>");
                out.println("<tr><td colspan=\"2\"><hr noshade/></td></tr>");
                out.println("<tr><th colspan=\"2\" align=\"left\"><h2 class=\"tituloGrande\">Miembros de la comunidad</h2></th></tr>");

                //Lista de miembros de la comunidad

                out.println("<tr><td colspan=\"2\"><table>");

                MicroSite ms = null;
                if(wp instanceof MicroSite)
                {
                    ms = (MicroSite)wp;
                    Iterator<Member> itmms = ms.listMembers();
                    ncol=0;
                    while (itmms.hasNext()) {
                        Member mms = itmms.next();
                        out.println("<tr>");
                        if(mms.getAccessLevel()!=Member.LEVEL_OWNER)
                        {
                            out.println("<td>");
                            out.println("<p align=\"right\"><label for=\"" + mms.getId() + "\">"+mms.getUser().getFullName()+"</label>&nbsp;-&nbsp;<select name=\"memberlevelaccess\" id=\""+mms.getId()+"\">" +getStrMemberLevelAccess(mms)+"</select></p>");
                            out.println("</td>");
                        }
                        else
                        {
                            out.println("<tr>");
                            out.println("<td>");
                            out.println("<p  align=\"right\">"+mms.getUser().getFullName()+" - Propietario de la comunidad.</p>");
                            out.println("</td>");
                        }
                        out.println("</tr>");
                    }
                }
                out.println("</table>");
                out.println("</td></tr>");
                out.println("</tbody>");
                out.println("<tfoot>");
                out.println("<tr><td colspan=\"2\"><hr noshade/><p>");
                out.println("<button dojoType=\"dijit.form.Button\" type=\"submit\" name=\"btn_save\">Actualizar</button>");

                SWBResourceURL urldel = paramRequest.getActionUrl();
                urldel.setParameter("act","remove"); 
                urldel.setParameter("suri", ms.getURI());

                out.println("<button dojoType=\"dijit.form.Button\" type=\"button\" name=\"btn_del\" onclick=\"if(confirm('¿Estás seguro de querer eliminar esta comunidad?')){window.location='"+urldel+"';}\">Eliminar</button>");

                SWBResourceURL urlback = paramRequest.getRenderUrl();
                urlback.setCallMethod(SWBResourceURL.Call_STRATEGY);
                urlback.setParameter("act", "view");
                urlback.setMode(SWBResourceURL.Mode_VIEW);

                out.println("<button dojoType=\"dijit.form.Button\" type=\"button\" name=\"btn_save\" onclick=\"window.location='"+urlback+"';\">Cancelar</button>");
                out.println("</p></td></tr>");
                out.println("</tfoot>");
                out.println("</table>");
                out.println("</form>");
                out.println("</div>");
                
            }
        }
%>

    </body>

<%!

    private String getStrMemberLevelAccess(Member member)
    {
        int level = member.getAccessLevel();
        StringBuffer ret = new StringBuffer();
        ret.append("\n<option value=\""+member.getUser().getId()+"|0\">Cancelar suscripción</option>");
        ret.append("\n<option value=\""+member.getUser().getId()+"|"+Member.LEVEL_EDIT+"\" "+(level==Member.LEVEL_EDIT?"selected":"")+">Participar en comunidad</option>");
        ret.append("\n<option value=\""+member.getUser().getId()+"|"+Member.LEVEL_ADMIN+"\" "+(level==Member.LEVEL_ADMIN?"selected":"")+">Administrar comunidad</option>");
        return ret.toString();
    }

    private Member getMember(User user, MicroSite site)
    {
        //System.out.println("getMember:"+user+" "+site);
        if(site!=null)
        {
            Iterator<Member> it=Member.ClassMgr.listMemberByUser(user,site.getWebSite());
            while(it.hasNext())
            {
                Member mem=it.next();
                //System.out.println("mem:"+mem+" "+mem.getMicroSite());
                if(mem.getMicroSite().equals(site))
                {
                   return mem;
                }
            }
        }
        return null;
    }

%>
