<%--
    Document   : treeWidget
    Created on : 30/12/2008, 05:09:54 PM
    Author     : Jei
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, org.semanticwb.*, org.semanticwb.*, org.semanticwb.portal.api.*, org.semanticwb.model.*"%>
<%!
    public String getLocaleString(String key, String lang)
    {
        return SWBUtils.TEXT.getLocaleString("locale_swb_admin", key, new Locale(lang));
    }
%>
<%
    User user = SWBContext.getAdminUser();
    if (user == null)
    {
        response.sendError(403);
        return;
    }
    String lang = user.getLanguage();

    String id;
    String showRoot;
    String rootLabel;
    String url;

    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    if (paramRequest != null)
    {
        id = paramRequest.getArgument("id", "tree");
        showRoot = paramRequest.getArgument("showRoot", "false");
        rootLabel = paramRequest.getArgument("rootLabel");
        SWBResourceURL surl = paramRequest.getRenderUrl().setMode("json").setCallMethod(paramRequest.Call_DIRECT);
        surl.setParameter("id", id);
        url = surl.toString();
    } else
    {
        id = request.getParameter("id");
        showRoot = request.getParameter("showRoot");
        rootLabel = request.getParameter("rootLabel");
        if (id == null)
        {
            id = "tree";
        }
        if (showRoot == null)
        {
            showRoot = "false";
        }
        url = SWBPlatform.getContextPath() + "/swbadmin/jsp/Tree.jsp?id=" + id;
    }
    //System.out.println("id:"+id);
    if (rootLabel != null)
    {
        rootLabel = "rootLabel=\"" + rootLabel + "\"";
    } else
    {
        rootLabel = "";
    }
    String store = id + "Store";
    String model = id + "Model";
    String menu = id + "Menu";
%>
<!-- menu -->
<ul dojoType="dijit.Menu" id="<%=menu%>" style="display: none;" onOpen="hideApplet(true);" onClose="hideApplet(false);">
    <li dojoType="dijit.MenuItem">DUMMY</li>
</ul>
<div dojoType="dojo.data.ItemFileWriteStore" jsId="<%=store%>" url="<%=url%>"></div>
<div dojoType="dijit.tree.ForestStoreModel" jsId="<%=model%>" store="<%=store%>" rootId="root" <%=rootLabel%> childrenAttrs="children"></div>
<div dojoType="dijit.Tree" id="<%=id%>" model="<%=model%>" dndController="dijit._tree.dndSource" betweenThreshold_="8" persist="false" showRoot="<%=showRoot%>">
    <script type="dojo/method" event="onClick" args="item, node">
        //console.log("onClick");
        
        if(item)
        {
            act_treeNode=node;
            //alert("onOpen");
            //getHtml('/swb/swbadmin/jsp/viewProps.jsp?id='+encodeURIComponent(id), "vprop");
            executeTreeNodeEvent(<%=store%>,item,"onClick");
        }
    </script>
    <script type="dojo/method" event="onOpen" args="item, node">                                    
        //console.log("onOpen");
        
        if(item)
        {
            act_treeNode=node;
            //alert("onOpen");
            executeTreeNodeEvent(<%=store%>,item,"onOpen");
        }                                    
    </script>
    <script type="dojo/method" event="onDblClick" args="item, node">
        //console.log("onDblClick");
        //printObjProp(event);
        if(item)
        {
            act_treeNode=node;
            executeTreeNodeEvent(<%=store%>,item,"onDblClick");
        }
    </script>
    <script type="dojo/method" event="onDndDrop" args="source,nodes,copy,target">
        //console.log("onDndDrop");
        
        //alert(source+" "+nodes+" "+copy+" "+this.containerState);
        // summary:
        //		Topic event processor for /dnd/drop, called to finish the DnD operation..
        //		Updates data store items according to where node was dragged from and dropped
        //		to.   The tree will then respond to those data store updates and redraw itself.
        // source: Object: the source which provides items
        // nodes: Array: the list of transferred items
        // copy: Boolean: copy items, if true, move items otherwise
        
        var newParentItem=source.tree.dropNode.item;
        var childItem=source.tree.dragNode.item;
        var oldParentItem=source.tree.dragNode.getParent().item;

        if(this.containerState == "Over")
        {
            this.isDragging = false;

            if(childItem && oldParentItem && newParentItem && oldParentItem!=newParentItem && childItem!=newParentItem)
            {
                var ac=confirm("<%=getLocaleString("aceptmove", lang)%>");
                if(ac)
                {
                    var f=showStatusURL('<%=SWBPlatform.getContextPath()%>/swbadmin/jsp/drop.jsp?suri='+encodeURIComponent(childItem.id)+'&newp='+encodeURIComponent(newParentItem.id)+'&oldp='+encodeURIComponent(oldParentItem.id)+'&copy='+copy,true);
                    if(f && !copy)
                    {
                        //model.pasteItem(childItem, oldParentItem, newParentItem, copy);
                        pasteItemByURIs(childItem.id,oldParentItem.id,newParentItem.id);
                        reloadTab(childItem.id);
                        this.tree._expandNode(source.tree.dropNode);
                    }
                }
            }
        }
        //console.log(this);
        this.onDndCancel();
        this.isDragging=false;
        this.mouseDown=false;
        this.containerState="";                                    

    </script>
    <script type="dojo/method" event="checkItemAcceptance" args="node,source">    
        //console.log("checkItemAcceptance");
        //console.log(source);
        //console.log(node);        
        //if(source.tree && source.tree.id == "collectionsTree"){
        //    return true;
        //}
        var ret=false;
        var dropNode = dijit.getEnclosingWidget(node);
        var dragNode = act_treeNode;

        source.tree.dropNode=dropNode;
        source.tree.dragNode=dragNode;

        //self.status="checkItemAcceptance-->dropNode"+dropNode+" dragSupport:"+dragNode.item.dragSupport;
        if(dropNode && dragNode)
        {
            var dragItem=dragNode.item;
            var dropItem=dropNode.item;
            if(dragItem!=dropItem && !isParent(dragNode,dropNode) && matchDropLevel(dragNode,dropNode))
            {
                for (var m in dropItem.dropacc) 
                {
                    //alert(dropItem.dropacc[m]);
                    if(dragItem.type.toString()==dropItem.dropacc[m].toString())
                    {
                        ret=true;   
                    }
                }
            }
            //alert(dragItem.type+" "+dropItem.dropacc.length+" "+(dragItem.type.toString() in dropItem.dropacc));
            //alert("("+dragItem.type.toString()+")("+dropItem.type.toString()+")");
        }
        //alert(this.current);
        //self.status="checkItemAcceptance-->ret:"+ret;
        return ret;
    </script>
    <script type="dojo/method" event="checkAcceptance" args="source,nodes">    
        //console.log("checkAcceptance");
        
/*        
        if(!this.onDndStartRegister)
        {
            this.onDndStartRegister=true;
            this.onDndStart=function(source,nodes,copy)
            {
                console.log("onDndStart");
                if(nodes[0].className.indexOf("dijitActive")==-1)
                {
                    this.stopDrag();
                    //return false;
                }  
                //return true;
            }
        }                 
*/    
        //console.log(source);
        //console.log(nodes);
        //console.log(dojo);
        //console.log(dijit);
        //console.log(dojo.dnd.Manager());
        //source.tree.dndController.stopDrag();           
        
        if(nodes[0].className.indexOf("dijitActive")==-1)
        {
            var manager=dojo.dnd.Manager();
            
            /*
            //dojo.dnd.Manager().makeAvatar();
            
            manager.events = [];
            if(manager.avatar!=null)manager.avatar.destroy();
            manager.avatar = null;
            manager.source = this.target = null;
            manager.nodes = [];            
            
            return false;
            //this.stopDrag();
            */
            throw "Nothing to Drag...";
        }  

        //this.stopDrag();
        
        act_treeNode=null;
        dojo.forEach(nodes, function(node, idx)
        {
            act_treeNode=dijit.getEnclosingWidget(node);
        }, this);
        //var m=dojo.dnd.manager();
        //m.canDrop(false);
        if(act_treeNode!=null)
        {
            //self.status="checkAcceptance-->act_treeNode:"+act_treeNode.item.id+" drag:"+act_treeNode.item.dragSupport;
            //alert(act_treeNode.item.id);
            if(act_treeNode.item.dragSupport=="true")return true;
        }else
        {
            self.status="checkAcceptance-->act_treeNode:"+act_treeNode;
            act_treeNode=null;
        }
        return false;
    </script>
    <script type="dojo/method" event="onDndStart" args="a,b,c">    
        //console.log("onDndStart");
        //console.log(a);
        //console.log(b);
        //console.log(c);
        //alert("Hola");
        /*
        if(this.isSource){
            this._changeState("Source",this==_1a?(_1c?"Copied":"Moved"):"");
        }
        var _1d=this.checkAcceptance(_1a,_1b);
        this._changeState("Target",_1d?"":"Disabled");
        if(_1d){
            dojo.dnd.manager().overSource(this);
        }
        this.isDragging=true;
        */
    </script>
    <script type="dojo/method" event="getIconClass" args="item, opened">
        if(item)
        {
            try
            {
                return <%=store%>.getValue(item, "icon");
            }catch(err)
            {
                //return (!item||this.model.mayHaveChildren(item))?(opened?"dijitFolderOpened":"dijitFolderClosed"):"dijitLeaf";
                return "swbIconTemplateGroup";
            }
        }
    </script>    
    <script type="dojo/connect">
        //console.log("connect");
        registerTree(this);
        
        var menuEmpty = dijit.byId("<%=menu%>");
        //menuEmpty.targetNodeIds=[this.domNode];
        menuEmpty.selector=".dijitTreeNode";
        menuEmpty.bindDomNode(this.domNode);

        <%=store%>.controllerURL="/swbadmin/jsp/Tree.jsp";
        dojo.dnd.Avatar.prototype._generateText = function()
        {
            return (this.manager.copy ? "<%=getLocaleString("referencing", lang)%>" : "<%=getLocaleString("moving", lang)%>") +
            " "+this.manager.nodes.length + " " +
            (this.manager.nodes.length != 1 ? "<%=getLocaleString("nodes", lang)%>" : "<%=getLocaleString("node", lang)%>");
        };
        
        dojo.connect(menuEmpty, "_openMyself", this, function(e)
        {
            //alert("_openMyself");
            var treeNode = dijit.getEnclosingWidget(e.target);
            //console.log(treeNode.item);
            treeNode.tree.dndController.onDndCancel();    

            var ch = menuEmpty.getChildren();
            //console.log("menu children is "+ch);
            if (ch && ch != "undefined")
            {
                dojo.forEach(ch, function(child)
                {
                    //console.log("Remving old child "+child);
                    menuEmpty.removeChild(child);
                });
            }
            if(treeNode.item.menus)
            {
            //console.log("Adding new submenus");
                for (var m in treeNode.item.menus)
                {
                    var menu = treeNode.item.menus[m];
                    //console.log("Adding submenu " + mstr);
                    var mi = document.createElement('div')
                    var sm;
                    if(menu.title=="_")
                    {
                        sm = new dijit.MenuSeparator();
                    }else
                    {
                        sm = new dijit.MenuItem(
                        {
                            label: menu.title instanceof Array?menu.title[0]:menu.title,
                            iconClass:menu.icon instanceof Array?menu.icon[0]:menu.icon,
                            action: menu.action instanceof Array?menu.action[0]:menu.action
                        }, mi);
                        sm.onClick = function(ele)
                        {
                            var m=dijit.getEnclosingWidget(ele.target);
                            //console.log("e.target:"+e.target);
                            //console.log("this"+this);
                            //console.log("this.store:"+this.store);
                            executeAction(<%=store%>, treeNode.item, m.action)
                        };
                    }
                    menuEmpty.addChild(sm);
                }
            }            
            //console.log("End");
        });
    </script>
</div>
