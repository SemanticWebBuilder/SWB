<%@page import="java.util.HashSet"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.model.SWBContext"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Check Cicle</title>
    </head>
    <body>
        <h1>Check Cicle2</h1>
        <pre>
<%
    String rpt=request.getParameter("rpt");
    String rps=request.getParameter("rps");
    if(rpt!=null && rps!=null)
    {
        WebSite site=SWBContext.getWebSite(rps);
        WebPage wpage=site.getWebPage(rpt);
        if(wpage!=null)
        {
            out.println("Referencia Ciclica Eliminada:"+wpage.getId());
            wpage.removeParent();
        }
    }

    Iterator<WebSite> wsit=SWBContext.listWebSites();
    while (wsit.hasNext())
    {
        WebSite site=wsit.next();
        out.print("Site:"+site.getId());
        out.print("<br/>");
        Iterator<WebPage> it=site.listWebPages();
        while (it.hasNext())
        {
            WebPage elem = it.next();
            /*
            if(elem.getParent()!=null)
            {
                out.println("Check:"+elem.getId()+" --> "+elem.getParent().getId());
                if(elem.getId().equals(elem.getParent().getId()))
                {
                    out.println("Referencia Ciclica Eliminada:"+elem.getId());
                    elem.setParent(null);
                }
            }
            */
            HashSet set=new HashSet();
            set.add(elem);
            WebPage parent=elem.getParent();
            while(parent!=null)
            {
                if(set.contains(parent))
                {
                    out.print("Cicle:"+elem.getId()+" --> "+parent.getId());
                    out.print("<br/>");
                    break;
                }else
                {
                    set.add(parent);
                }
                parent=parent.getParent();
             }
        }
    }
%>
        </pre>
    </body>
</html>
