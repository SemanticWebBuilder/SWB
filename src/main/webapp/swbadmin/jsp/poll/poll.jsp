<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.model.GenericIterator"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.platform.SemanticProperty"%>
<%@page import="org.semanticwb.model.SWBModel"%>
<%@page import="org.semanticwb.model.Descriptiveable"%>
<%@page import="org.semanticwb.platform.SemanticClass"%>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.portal.api.*"%>
<%@page import="org.w3c.dom.*"%>
<%@page import="org.semanticwb.Logger"%>
<%!
 private static String poll = "pollJsp_";
%>
<%

        Resource base = paramRequest.getResourceBase();
        String webWorkPath = (String) SWBPortal.getWebWorkPath() +  base.getWorkPath();


        try {
            Document dom = SWBUtils.XML.xmlToDom(base.getXml());
            if (dom != null) {
                NodeList node = dom.getElementsByTagName("option");
                if (!"".equals(base.getAttribute("question", "").trim()) && node.getLength() > 1) {
                    if (base.getAttribute("cssClass") != null && !base.getAttribute("cssClass").trim().equals("")) {
                        %>
                            <div class="<%=base.getAttribute("cssClass")%>">
                        <%
                    } else {
                        %>
                            <div class="swb-encuesta">
                        <%
                    }

                    if (base.getAttribute("header") != null) {
                        String style = "";
                        if (base.getAttribute("headerStyle") != null) {
                            style = "style=\"" + base.getAttribute("headerStyle") + "\"";
                        }
                        %>
                            <h1 <%=style%>><%=base.getAttribute("header")%></h1>
                        <%
                    }
                    %>
                    <form name="frmEncuesta" id="frmEncuesta_<%=base.getId()%>" action="<%=paramRequest.getRenderUrl()%>" method="post" style="color:'<%=base.getAttribute("textcolor")%>'">
                    <%
                    if (!"".equals(base.getAttribute("imgencuesta", "").trim())) {
                        %>
                            <img src="<%=webWorkPath%><%=base.getAttribute("imgencuesta")%>" border="0" alt="<%=base.getAttribute("question")%>"/>
                        <%
                    }
                    %>
                        <p><%=base.getAttribute("question")%></p>
                    <%
                    for (int i = 0; i < node.getLength(); i++) {
                        %>
                        <label><input type="radio" name="radiobutton" value="enc_votos<%=(i + 1)%>" />
                            <%=node.item(i).getChildNodes().item(0).getNodeValue()%></label><br />
                        <%
                    }
                    %>
                    <p><span>
                    <%
                    if (!"".equals(base.getAttribute("button", ""))) {
                        %>
                        <input type="image" name="votar" src="<%=webWorkPath%><%=base.getAttribute("button").trim()%>" onClick="buscaCookie(this.form); return false;"/>
                        <%
                    } else {
                        %>
                            <input type="button" name="votar" value="<%=base.getAttribute("msg_tovote", paramRequest.getLocaleString("msg_tovote"))%>" onClick="buscaCookie(this.form);"/>
                        <%
                    }
                    %>
                        </span></p>
                    <%

                    SWBResourceURLImp url = new SWBResourceURLImp(request, base, paramRequest.getWebPage(), SWBResourceURL.UrlType_RENDER);
                    url.setMode("showResults");
                    url.setParameter("NombreCookie", "VotosEncuesta" + base.getId());
                    url.setCallMethod(paramRequest.Call_DIRECT);

                    boolean display = Boolean.valueOf(base.getAttribute("display", "true")).booleanValue();
                    if (display) {
                        %>
                            <p>
                            <a href="javascript:;" onclick="javascript:abreResultados('<%=url.toString(true)%>')"><%=base.getAttribute("msg_viewresults", paramRequest.getLocaleString("msg_viewresults"))%></a>
                            </p>
                        <%
                    } else {
                        %>
                            <p>
                            <a href="javascript:;" onclick="getHtml('<%=url%>','<%=poll%><%=base.getId()%>'); expande();"><%=base.getAttribute("msg_viewresults", paramRequest.getLocaleString("msg_viewresults"))%></a>
                            <div id="<%=poll%><%=base.getId()%>">
                            </div>
                            </p>
                        <%
                    }
                    if ("1".equals(base.getAttribute("wherelinks", "").trim()) || "3".equals(base.getAttribute("wherelinks", "").trim())) {
                        %>
                            <%=getLinks(dom.getElementsByTagName("link"), paramRequest.getLocaleString("usrmsg_Encuesta_doView_relatedLink"))%>
                        <%
                    }
                    %>
                        <input type="hidden" name="NombreCookie" value="VotosEncuesta<%=base.getId()%>"/>
                        </form>
                        </div>
                    <%

                    StringBuilder win = new StringBuilder();
                    win.append("menubar=" + base.getAttribute("menubar", "no"));
                    win.append(",toolbar=" + base.getAttribute("toolbar", "no"));
                    win.append(",status=" + base.getAttribute("status", "no"));
                    win.append(",location=" + base.getAttribute("location", "no"));
                    win.append(",directories=" + base.getAttribute("directories", "no"));
                    win.append(",scrollbars=" + base.getAttribute("scrollbars", "no"));
                    win.append(",resizable=" + base.getAttribute("resizable", "no"));
                    win.append(",width=" + base.getAttribute("width", "360"));
                    win.append(",height=" + base.getAttribute("height", "260"));
                    win.append(",top=" + base.getAttribute("top", "125"));
                    win.append(",left=" + base.getAttribute("left", "220"));
                    %>

                    <script type="text/javascript">
                    dojo.require("dojo.fx");

                    function buscaCookie(forma) {
                        var numcom = getCookie(forma.NombreCookie.value);
                        if(numcom == "SI") {
                            if ("true".equals(base.getAttribute("oncevote", "true").trim()) && !"0".equals(base.getAttribute("vmode", "0").trim())) {
                                alert('<%=paramRequest.getLocaleString("msgDoView_msgVote")%>');
                            }
                        }
                        grabaEncuesta(forma);
                    }
                    function setCookie(name) {
                        document.cookie = name;
                        var expDate = new Date();
                        expDate.setTime(expDate.getTime() + ( 720 * 60 * 60 * 1000) );
                        expDate = expDate.toGMTString();
                        var str1 = name + "=SI; expires=" + expDate + ";Path=/";
                        document.cookie = str1;
                    }
                    function getCookie (name) {
                        var arg = name + "=";
                        var alen = arg.length;
                        var clen = document.cookie.length;
                        var i = 0;
                        while (i < clen)
                        {
                           var j = i + alen;
                           if (document.cookie.substring(i, j) == arg)
                                return getCookieVal (j);
                            i = document.cookie.indexOf(" ", i) + 1;
                            if (i == 0) break;
                        }
                        return null;
                    }
                    function getCookieVal (offset) {
                        var endstr = document.cookie.indexOf (";", offset);
                        if (endstr == -1)
                            endstr = document.cookie.length;
                        return unescape(document.cookie.substring(offset, endstr));
                    }
                   function grabaEncuesta(forma) {
                            var optValue;
                            for(var i=0; i< forma.length; i++) {
                                if(forma.elements[i].type == "radio") {
                                    if(forma.elements[i].checked) {
                                        optValue = forma.elements[i].value;
                                        break;
                                    }
                                }
                            }
                            if(optValue != null) {
                                <%
                                if (display) {
                                %>
                                    window.open('<%=url.toString()%>&radiobutton='+optValue,'_newenc','<%=win%>');
                                <%
                                } else {
                                %>
                                    getHtml('<%=url.toString()%>&radiobutton='+optValue,'<%=poll%><%=base.getId()%>'); expande();
                                <%
                                }
                                %>
                            }else {
                                alert('<%=paramRequest.getLocaleString("msgDoView_msgAnswer")%>');
                            }
                    }

                    function abreResultados(ruta) {
                        window.open(ruta,'_newenc','<%=win%>');
                    }

                    function expande() {
                        var anim1 = dojo.fx.wipeIn( {node:"<%=poll%><%=base.getId()%>", duration:500 });
                        var anim2 = dojo.fadeIn({node:"<%=poll%><%=base.getId()%>", duration:650});
                        dojo.fx.combine([anim1,anim2]).play();
                     }

                    function collapse() {
                        var anim1 = dojo.fx.wipeOut( {node:"<%=poll%><%=base.getId()%>", duration:500 });
                        var anim2 = dojo.fadeOut({node:"<%=poll%><%=base.getId()%>", duration:650});
                        dojo.fx.combine([anim1, anim2]).play();
                     }

                    </script>
                    <%
                }
            }
        } catch (Exception e) {
            //log.error(paramRequest.getLocaleString("error_Encuesta_doView_resource") + " " + restype + " " + paramRequest.getLocaleString("error_Encuesta_doView_method"), e);
        }
%>

<%!
    private String getLinks(NodeList links, String comment) {
        StringBuffer ret = new StringBuffer("");
        if (links==null) return ret.toString();
        String _comment=comment;
        for (int i = 0; i < links.getLength(); i++)
        {
            String value = links.item(i).getChildNodes().item(0).getNodeValue().trim();
            if(!"".equals(value.trim()))
            {
                int idx = value.indexOf(" /wblink/ ");
                if (idx > -1)
                {
                    _comment = value.substring(idx + 10);
                    value = value.substring(0, idx);
                }
                ret.append("<a href=\"" + value + "\" target=\"_newlink\">"+ _comment + "</a><br /> ");
                _comment=comment;
            }
        }
        return ret.toString();
    }
%>