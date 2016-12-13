<%--
    Document   : jsonTree
    Created on : 03-jul-2013, 15:12:19
    Author     : javier.solis.g
--%>
<%@page import="java.util.Iterator"%>
<%@page import="org.semanticwb.model.*"%>
<%@page import="org.json.*"%>
<%@page contentType="text/json" pageEncoding="UTF-8"%>
<%!
    JSONObject getObject(WebPage page, String lang) throws Exception
    {
        JSONObject node=new JSONObject();
        node.put("name", page.getDisplayName(lang));
        JSONArray arr=new JSONArray();
        int x=0;
        Iterator<WebPage> it=page.listChilds(lang, true, false, false, null);
        while(it.hasNext())
        {
            WebPage ch=it.next();
            JSONObject nch=getObject(ch,lang);
            arr.put(nch);
            x++;
        }
        node.put("size", page.getViews());
        node.put("colour", "#dbdc7f");
        if(x>0)node.put("children", arr);
        return node;
    }
%>
<%
    String model=request.getParameter("model");
    String lang=request.getParameter("lang");
    if(model==null)model="demo";
    WebSite site=SWBContext.getWebSite(model);
    if(request.getParameter("wpage")!=null)
    {
            WebPage wpage=site.getWebPage(request.getParameter("wpage"));
            if(wpage!=null)
            {
                out.println(getObject(wpage, lang));
            }
    }else
    {
            out.println(getObject(site.getHomePage(), lang));
    }
%>