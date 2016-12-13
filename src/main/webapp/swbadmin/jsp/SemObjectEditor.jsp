<%@page import="java.lang.reflect.Field"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.*,org.semanticwb.platform.*,org.semanticwb.portal.*,org.semanticwb.model.*,java.util.*,org.semanticwb.base.util.*"%>
<%!
    public SemanticClass validateClass(HttpServletRequest request, SemanticClass cls)
    {
        SemanticClass ret=cls;
        //System.out.println("cls"+cls);
        Iterator<SemanticProperty> it=cls.listProperties();
        while (it.hasNext())
        {
            SemanticProperty prop = it.next();
            //System.out.println("prop"+prop);
            SemanticObject dp=prop.getDisplayProperty();
            if(dp!=null)
            {
                DisplayProperty disp=new DisplayProperty(dp);
                if(disp.getFormElement() !=null && disp.getFormElement().instanceOf(ClassElement.sclass))
                {
                    String value=request.getParameter(prop.getName());
                    if(value!=null)
                    {
                        try
                        {
                            Class cl=Class.forName(value);
                            //System.out.println("Class:"+cl);
                            Field field=cl.getField("classType");
                            if(field!=null)
                            {
                                //System.out.println("field:"+field);
                                Object obj=field.get(cl);
                                if(obj instanceof SemanticClass)
                                {
                                    ret=(SemanticClass)obj;
                                }
                                //System.out.println("Field Val:"+field.get(cl));
                            }
                        }catch(Exception noe){}
                    }
                }
            }
        }
        return ret;
    }
%>
<%
    User user=SWBContext.getAdminUser();
    if(user==null)
    {
        response.sendError(403);
        return;
    }
%>
<%
    String lang="es";
    if(user!=null)lang=user.getLanguage();
    response.setHeader("Cache-Control", "no-cache"); 
    response.setHeader("Pragma", "no-cache"); 
    String suri=request.getParameter("suri");
    String scls=request.getParameter("scls");
    String sref=request.getParameter("sref");
    String sprop=request.getParameter("sprop");
    String chcls=request.getParameter("chcls");

    String reloadTab=request.getParameter("reloadTab");
    //System.out.println("SemObjectEditor suri:"+suri+" scls:"+scls+" sref:"+sref+" sprop:"+sprop);
    //System.out.println("debug:1");
    if(suri==null && scls==null)
    {
        String code=SWBUtils.IO.readInputStream(request.getInputStream());
        //System.out.println(code);
        String uri=SWBContext.getAdminWebSite().getHomePage().getEncodedURI();
        String cls=SWBContext.getAdminWebSite().getHomePage().getSemanticObject().getSemanticClass().getEncodedURI();

        //uri=SWBContext.getWebSite("sep").getProject("proyecto1").getEncodedURI();
        //cls=SWBContext.getWebSite("sep").getProject("proyecto1").getSemanticObject().getSemanticClass().getEncodedURI();
%>
        <a href="?suri=<%=uri%>">edit</a>
        <a href="?scls=<%=cls%>&sref=<%=uri%>">create</a>
<%
        return;
    }
    String smode=request.getParameter("smode");
try
{

    //System.out.println("debug:2");
    SemanticOntology ont=SWBPlatform.getSemanticMgr().getOntology();
    if(suri==null) //es una creacion
    {
        //System.out.println("debug:3");
        SemanticClass cls=SWBPlatform.getSemanticMgr().getVocabulary().getSemanticClass(scls);
        SemanticObject ref=SWBPlatform.getSemanticMgr().getOntology().getSemanticObject(sref);

        boolean canAdd=SWBPortal.getAdminFilterMgr().haveClassAction(user, cls, AdminFilter.ACTION_ADD);
        if(!canAdd)return;

        //System.out.println("Validar...");
        cls=validateClass(request, cls);
        //System.out.println("Valido...");

        SWBFormMgr frm=new SWBFormMgr(cls,ref,null);
        frm.setLang(lang);
        frm.setFilterHTMLTags(false);
        frm.addHiddenParameter("sprop", sprop);
        if(reloadTab!=null)frm.addHiddenParameter("reloadTab",reloadTab);
        frm.setSubmitByAjax(true);
        frm.setType(SWBFormMgr.TYPE_DOJO);
        if(chcls!=null)frm.setSelectClass(true);

        //System.out.println("scls"+scls+" sref"+sref+" sprop:"+sprop);
        SemanticObject obj=null;
        //if(smode!=null)
        {
            obj=frm.processForm(request);
        }
        if(obj!=null)
        {
            if(smode.equals(SWBFormMgr.MODE_CREATE))
            {
                SemanticProperty prop=null;
                if(sprop!=null)prop=SWBPlatform.getSemanticMgr().getVocabulary().getSemanticProperty(sprop);

                if(prop!=null && prop.hasInverse())
                {
                    //System.out.println("prop:"+prop.getURI()+" "+prop.hasInverse()+" "+prop.getInverse());
                    if(prop.getInverse().getCardinality()==0)
                    {
                       obj.addObjectProperty(prop.getInverse(), ref);
                    }else
                    {
                        obj.setObjectProperty(prop.getInverse(), ref);
                    }
                }else if(prop!=null && !prop.hasInverse())
                {
                    //System.out.println("prop:"+prop.getURI()+" "+prop.hasInverse()+" "+prop.getInverse());
                    if(prop.getCardinality()==0)
                    {
                        ref.addObjectProperty(prop, obj);
                    }else
                    {
                        ref.setObjectProperty(prop, obj);
                    }
                }


                //GenericObject gobj=cls.newGenericInstance(obj);
                //if(gobj instanceof WebPage)
                //{
                //    ((WebPage)gobj).setParent((WebPage)cls.newGenericInstance(ref));
                //}
                
                out.println("<script type=\"text/javascript\">");
                out.println("hideDialog();");
                if(!ref.instanceOf(SWBModel.sclass))out.println("reloadTreeNodeByURI('"+ref.getURI()+"');");                
                else out.println("reloadTreeNode();");                
                if(reloadTab!=null && reloadTab.equals("true"))out.println("reloadTab('"+ref.getURI()+"');");
                out.println("showStatus('"+SWBUtils.TEXT.scape4Script(obj.getSemanticClass().getDisplayName(lang))+" creado');");
                out.println("addNewTab('"+obj.getURI()+"','"+SWBPlatform.getContextPath()+"/swbadmin/jsp/objectTab.jsp"+"','"+SWBUtils.TEXT.scape4Script(obj.getDisplayName(lang))+"');");
                out.println("</script>");
            }
        }else
        {
            frm.setAction(SWBPlatform.getContextPath()+"/swbadmin/jsp/SemObjectEditor.jsp");
            //frm.addButton("<button dojoType='dijit.form.Button' type=\"submit\">Guardar</button>");
            frm.addButton(SWBFormButton.newSaveButton());
            //frm.addButton("<button dojoType='dijit.form.Button' onclick=\"dijit.byId('swbDialog').hide();\">Cancelar</button>");
            frm.addButton(SWBFormButton.newCancelButtonDlg());
            out.println(frm.renderForm(request));
            //out.println("hola...");
        }
    }else
    {
        //System.out.println("debug:5");

        SemanticObject obj=ont.getSemanticObject(suri);
        SemanticClass cls=obj.getSemanticClass();

        boolean canEdit=SWBPortal.getAdminFilterMgr().haveClassAction(user, cls, AdminFilter.ACTION_EDIT) && SWBPortal.getAdminFilterMgr().haveAccessToSemanticObject(user, obj);
        
        boolean classFullAccess = DisplayObject.getDisplayMode(cls).equals(DisplayObject.DISPLAYMODE_FULL_ACCESS) || DisplayObject.getDisplayMode(cls).equals(DisplayObject.DISPLAYMODE_FINAL);        //Nivel de acceso definido por clase en la ontologia
        
        
        //out.println("<fieldset>");
        //out.println("<div class=\"swbIcon2"+cls.getName()+"\"></div>");
        //out.println("</fieldset>");

        String mode=SWBFormMgr.MODE_EDIT;
        if(!canEdit)
        {
            mode=SWBFormMgr.MODE_VIEW;
        }


        //TODO: revisar mejor opcion
        String view=null;
        if(obj.getSemanticClass().equals(Resource.sclass))
        {
            int pmode=((org.semanticwb.model.Resource)obj.createGenericInstance()).getResourceType().getResourceMode();
            view="resourceMode"+pmode;
        }
        //System.out.println(view);

        //System.out.println("debug:6");
        SWBFormMgr frm=new SWBFormMgr(obj, view,mode);
        frm.setLang(lang);
        frm.setFilterHTMLTags(false);
        frm.setSubmitByAjax(true);
        frm.setType(SWBFormMgr.TYPE_DOJO);

        if(smode!=null)
        {
            frm.processForm(request);
            out.println("<script type=\"text/javascript\">");
            //out.println("alert('mtreeStore:'+mtreeStore);");
            out.println("updateTreeNodeByURI('"+obj.getURI()+"');");

            String icon=SWBContext.UTILS.getIconClass(obj);
            out.println("setTabTitle('"+obj.getURI()+"','"+SWBUtils.TEXT.scape4Script(obj.getDisplayName(lang))+"','"+icon+"');");
            Iterator<SemanticObject> it2=obj.listRelatedObjects();
            while(it2.hasNext())
            {
                SemanticObject aux=it2.next();
                out.println("reloadTab('"+aux.getURI()+"');");
            }
            out.println("showStatus('"+SWBUtils.TEXT.scape4Script(obj.getSemanticClass().getDisplayName(lang))+" actualizado');");
            out.println("</script>");
        }
        frm.setAction(SWBPlatform.getContextPath()+"/swbadmin/jsp/SemObjectEditor.jsp");

        //frm.addButton("<button dojoType='dijit.form.Button' type=\"submit\">Guardar</button>");

        if(canEdit)
        {
            frm.addButton(SWBFormButton.newSaveButton());
        }

        if(user!=null)
        {
            boolean isfavo=user.hasFavorite(obj);
            if(!isfavo)
            {
                //frm.addButton("<button dojoType='dijit.form.Button' onclick=\"showStatusURL('"+SWBPlatform.getContextPath()+"/swbadmin/jsp/favorites.jsp?suri="+obj.getEncodedURI()+"&act=active"+"');\">Agregar a Favoritos</button>");
                frm.addButton(new SWBFormButton().setTitle("Agregar a Favoritos", "es").setTitle("Add to Favorites", "en").setAttribute("onclick", "showStatusURL('"+SWBPlatform.getContextPath()+"/swbadmin/jsp/favorites.jsp?suri="+obj.getEncodedURI()+"&act=active"+"');").setBusyButton(true));
            }else
            {
                //frm.addButton("<button dojoType='dijit.form.Button' onclick=\"showStatusURL('"+SWBPlatform.getContextPath()+"/swbadmin/jsp/favorites.jsp?suri="+obj.getEncodedURI()+"&act=unactive"+"');\">Eliminar de Favoritos</button>");
                frm.addButton(new SWBFormButton().setTitle("Eliminar de Favoritos", "es").setTitle("Delete from Favorites", "en").setAttribute("onclick", "showStatusURL('"+SWBPlatform.getContextPath()+"/swbadmin/jsp/favorites.jsp?suri="+obj.getEncodedURI()+"&act=unactive"+"');").setBusyButton(true));
            }
        }

        if(canEdit && classFullAccess && SWBPortal.getAdminFilterMgr().haveClassAction(user, cls, AdminFilter.ACTION_DELETE))
        {
            if(obj.getBooleanProperty(Undeleteable.swb_undeleteable)==false)
            {
                if(user.getLanguage().equals("es"))
                {
                    frm.addButton(SWBFormButton.newDeleteButton().setAttribute("onclick", "if(confirm('¿Eliminar el elemento?'))showStatusURL('"+SWBPlatform.getContextPath()+"/swbadmin/jsp/delete.jsp?suri="+obj.getEncodedURI()+"');"));
                }else
                {
                    frm.addButton(SWBFormButton.newDeleteButton().setAttribute("onclick", "if(confirm('Delete element?'))showStatusURL('"+SWBPlatform.getContextPath()+"/swbadmin/jsp/delete.jsp?suri="+obj.getEncodedURI()+"');"));
                }
            }
        }

        out.println(frm.renderForm(request));
     }
}catch(Exception e){e.printStackTrace();}
%>
<!-- a href="#" onclick="submitUrl('/swb/swb',this); return false;">click</a -->