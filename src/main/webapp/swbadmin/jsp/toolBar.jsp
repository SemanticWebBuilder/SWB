<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.*,org.semanticwb.model.*,java.util.*,java.io.*"%>
<%!
    public String getLocaleString(String key, String lang)
    {
        return SWBUtils.TEXT.getLocaleString("locale_swb_admin", key, new Locale(lang));
    }
    
    public boolean validateNSPrefix(WebPage webpage)
    {
        boolean ret=true;
        if(webpage instanceof MenuItem)
        {
            if(((MenuItem)webpage).getNsPrefixFilter()!=null)
            {
                String pf=((MenuItem)webpage).getNsPrefixFilter();
                if(SWBPlatform.getSemanticMgr().getOntology().getRDFOntModel().getNsPrefixURI(pf)==null)ret=false;            
            }         
        }
        return ret;
    }

   void addChild(WebPage page, JspWriter out, User user) throws IOException
   {
        String lang=user.getLanguage();
        Iterator<WebPage> it=page.listVisibleChilds(lang);
        while(it.hasNext())
        {
            WebPage child=it.next();
            
            if(!validateNSPrefix(child))continue;
            
            if(SWBPortal.getAdminFilterMgr().haveAccessToWebPage(user, child))
            {
                if(user.haveAccess(child))
                {
                    if(child.listVisibleChilds(lang).hasNext())
                    {
                        out.println("		<div dojoType=\"dijit.PopupMenuItem\" iconClass_=\"swbIconWebPage\">");
                        out.println("			<span>"+child.getDisplayName(lang)+"</span>");
                        out.println("		<div dojoType=\"dijit.Menu\">");
                        addChild(child,out,user);
                        out.println("		</div>");
                        out.println("		</div>");
                    }else
                    {
                        //System.out.println("mnu:"+child.getClass());
                        if(child.getSemanticObject().instanceOf(MenuItem.sclass))
                        {                            
                            
                            String show=((MenuItem)child.getSemanticObject().createGenericInstance()).getShowAs();
                            if(show!=null && show.equals("DIALOG"))
                            {
                                out.println("            <div dojoType=\"dijit.MenuItem\" iconClass_=\"swbIconWebPage\" onclick=\"showDialog('"+child.getUrl()+"','"+SWBUtils.TEXT.scape4Script(child.getDisplayName(lang))+"');\">"+child.getDisplayName(lang)+"</div>");
                            }else
                            {
                                out.println("            <div dojoType=\"dijit.MenuItem\" iconClass_=\"swbIconWebPage\" onclick=\"addNewTab('"+child.getURI()+"','"+SWBPlatform.getContextPath()+"/swbadmin/jsp/menuTab.jsp"+"','"+SWBUtils.TEXT.scape4Script(child.getDisplayName(lang))+"');\">"+child.getDisplayName(lang)+"</div>");
                            }
                        }else
                        {
                            //out.println("            <div dojoType=\"dijit.MenuItem\" accelKey=\"Ctrl+S\" iconClass_=\"swbIconWebPage\" onclick=\"addNewTab('"+child.getURI()+"','"+child.getTitle()+"','"+SWBPlatform.getContextPath()+"/swbadmin/jsp/menuTab.jsp"+"');\">"+child.getTitle()+"</div>");
                            out.println("            <div dojoType=\"dijit.MenuItem\" iconClass_=\"swbIconWebPage\" onclick=\"addNewTab('"+child.getURI()+"','"+SWBPlatform.getContextPath()+"/swbadmin/jsp/menuTab.jsp"+"','"+SWBUtils.TEXT.scape4Script(child.getDisplayName(lang))+"');\">"+child.getDisplayName(lang)+"</div>");
                        }
                    }
                }
            }
        }
   }
%>
<%
    User user=SWBContext.getAdminUser();
    if(user==null)
    {
        response.sendError(403);
        return;
    }
    String lang=user.getLanguage();
    
    response.setHeader("Cache-Control", "no-cache"); 
    response.setHeader("Pragma", "no-cache");
%>
<div id="semwblogo" class="dijitReset dijitInline swbLogo"></div>
<!--    <span dojoType="dijit.Tooltip" connectId="semwblogo">Semantic WebBuilder</span>-->

<%
    String model=request.getParameter("model");
    String id=request.getParameter("id");
    if(model==null)model=SWBContext.WEBSITE_ADMIN;
    if(id==null)id="WBAd_mnu_Main";
    //System.out.println("model:"+model);
    //System.out.println("id:"+id);

    WebPage wp=SWBContext.getWebSite(model).getWebPage(id);
    Iterator<WebPage> it=wp.listVisibleChilds(lang);
    while(it.hasNext())
    {
        WebPage child=it.next();
        
        if(!validateNSPrefix(child))continue;
        
        if(SWBPortal.getAdminFilterMgr().haveAccessToWebPage(user, child))
        {
        //System.out.println(child);
        //System.out.println(child.getTitle()+" "+child.getTitle("es")+" "+child.getTitle("en"));
%>
    <div id="<%=child.getId()%>" dojoType="dijit.form.DropDownButton" iconClass_="swbIconWebPage">
        <script type="dojo/method" event="onClick">
        </script>
        <span><%=child.getDisplayName(lang)%></span>
        <div dojoType="dijit.Menu" onOpen="hideApplet(true);" onClose="hideApplet(false);">
<%      addChild(child,out,user);%>
        </div>
    </div>
<%
            String desc=child.getDescription(lang);
            if(desc!=null)
            {
%>
    <span dojoType="dijit.Tooltip" connectId="<%=child.getId()%>"><%=desc%></span>
<%
            }
        }

    }
%>
<span id="swblogout"><a href="?suri=<%=user.getEncodedURI()%>" onclick="addNewTab('<%=user.getURI()%>', null, '<%=SWBUtils.TEXT.scape4Script(user.getSemanticObject().getDisplayName(lang))%>');return false;"><%=user.getFullName()%></a> | <a href="<%=SWBPlatform.getContextPath()%>/login?wb_logout=true"><%=getLocaleString("logout",lang)%></a></span>
<!--    

    <div id="getMail" dojoType="dijit.form.ComboButton" optionsTitle="Mail Source Options">
        <script type="dojo/method" event="onClick">
        </script>
        <span>Get Mail</span>
        <ul dojoType="dijit.Menu">
            <li dojoType="dijit.MenuItem" >Yahoo</li>
            <li dojoType="dijit.MenuItem" >GMail</li>
        </ul>
    </div>
    <span dojoType="dijit.Tooltip" connectId="getMail">Click to download new mail.</span>

    <button
        id="newMsg" dojoType="dijit.form.Button"
        iconClass="mailIconNewMessage">
        New Message
        <script type="dojo/method" event="onClick">
            /* make a new tab for composing the message */
        </script>
    </button>
    <span dojoType="dijit.Tooltip" connectId="newMsg">Click to compose new message.</span>

    <button id="options" dojoType="dijit.form.Button" iconClass="swbIconWebPage">
        &nbsp;Options
        <script type="dojo/method" event="onClick">
            dijit.byId('optionsDialog').show();
        </script>
    </button>
    <div dojoType="dijit.Tooltip" connectId="options">Set various options</div>
-->    