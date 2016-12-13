<%@page contentType="text/html"%>
<%@page import="org.semanticwb.portal.resources.sem.newslite.*,java.util.*,java.text.SimpleDateFormat, org.semanticwb.portal.api.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>

<style type="text/css">
<!--
#interna_colIzquierda {width:750px; float:left; text-align:justify}
#interna_colIzquierda img {margin-right:10px; float:left; display:block}
#interna_colIzquierda h2 {font-size:1.3em; text-transform:uppercase; color:#939393; margin-bottom:10px}
#interna_colIzquierda h3 {color:#1C5DA4; text-transform:uppercase; font-size:1em; border-left:2px solid #E4E3E3; margin:0.2em 0; padding-left:0.3em}
#interna_colIzquierda p {margin-bottom:10px}
.resaltado {font-weight:bold}
.clear {clear:both; height:1px}
-->
</style>

<%
    SimpleDateFormat formatview = new SimpleDateFormat("dd/MM/yyy HH:mm:ss");
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    New onew=(New) request.getAttribute("new");
    String title=onew.getTitle();
    String description=onew.getDescription();
    String body=onew.getBody();
    String author=onew.getAuthor();
    if(author!=null && author.trim().equals(""))
    {
        author=null;
    }
    String source=onew.getSource();
    if(source!=null && source.trim().equals(""))
    {
        source=null;
    }
    String imgPhoto = SWBPortal.getContextPath() + "/swbadmin/jsp/SWBNewsLite/sinfoto.png";
    if (onew.getImage() != null)
    {
        int pos = onew.getImage().lastIndexOf("/");
        if (pos != -1)
        {
            String sphoto = onew.getImage().substring(pos + 1);
            onew.setImage(sphoto);
        }
        imgPhoto = SWBPortal.getWebWorkPath() + onew.getWorkPath() + "/" + onew.getImage();
    }
    String created=formatview.format(onew.getCreated());
    %>
    <div id="interna_colIzquierda">
        <h2><%=title%></h2>
        <img src="<%=imgPhoto%>" alt="<%=title%>" />
        <p><span class="resaltado">Resumen:</span><%=description%></p>
        <%
            if(author!=null)
            {
                %>
                <p><span class="resaltado">Autor:</span> <%=author%></p>
                <%
            }
        %>
        <%
            if(source!=null)
            {
                %>
                <p><span class="resaltado">Fuente:</span> <%=source%></p>
                <%
            }
        %>
        <p><span class="resaltado">Fecha de creación:</span> <%=created%></p>
        <div class="clear">&nbsp;</div>
        <p><%=body%></p>
        <p><a href="javascript:history.back();">Regresar</a></p>
    </div>
    <%    
%>