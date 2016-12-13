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
    String userRep = request.getParameter("userRep");
    String users[] = request.getParameterValues("users");
    String roles[] = request.getParameterValues("roles");
    String userg[] = request.getParameterValues("userg");
    String search = request.getParameter("s");
    String action = request.getParameter("uf_act");
    if(action!=null && action.trim().length()==0)action=null;
    
    String path=paramRequest.getRenderUrl().setCallMethod(3).toString();
    
/*    
    System.out.println("lang:"+lang);
    System.out.println("userRep:"+userRep);
    System.out.println("users:"+users);
    System.out.println("roles"+roles);
    System.out.println("userg"+userg);
    System.out.println("search:"+search);
    System.out.println("action:"+action);
*/    
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
                
                StringTokenizer st=new StringTokenizer(search,",;");
                if(!st.hasMoreTokens())
                {
                    out.println("<option value=\""+ur.getId()+"\">"+txt+"</option>");
                }
                while(st.hasMoreTokens())
                {
                    String t=st.nextToken().trim();                    
                    if(search.length()==0 || txt.toLowerCase().indexOf(t)>-1)
                    {
                        out.println("<option value=\""+ur.getId()+"\">"+txt+"</option>");
                        break;
                    }
                }
            }
        }
        return;
    }
    if(action!=null && users!=null)
    {
        UserRepository rep=UserRepository.ClassMgr.getUserRepository(userRep);
        if(action.equals("dal"))
        {
            for(int x=0;x<users.length;x++)
            {
                User usr=rep.getUser(users[x]);
                usr.removeAllRole();
                usr.removeAllUserGroup();
            }
        }else if(action.equals("dsl") && roles!=null && userg!=null)
        {
            for(int x=0;x<users.length;x++)
            {
                User usr=rep.getUser(users[x]);
                for(int y=0;y<roles.length;y++)
                {
                    Role role=rep.getRole(roles[y]);
                    usr.removeRole(role);
                }
                for(int y=0;y<userg.length;y++)
                {
                    UserGroup ug=rep.getUserGroup(userg[y]);
                    usr.removeUserGroup(ug);
                }
            }
        }else if(action.equals("asl") && roles!=null && userg!=null)
        {
            for(int x=0;x<users.length;x++)
            {
                User usr=rep.getUser(users[x]);
                for(int y=0;y<roles.length;y++)
                {
                    Role role=rep.getRole(roles[y]);
                    usr.addRole(role);
                }
                for(int y=0;y<userg.length;y++)
                {
                    UserGroup ug=rep.getUserGroup(userg[y]);
                    usr.addUserGroup(ug);
                }
            }
        }else if(action.equals("osl") && roles!=null && userg!=null)
        {
            for(int x=0;x<users.length;x++)
            {
                User usr=rep.getUser(users[x]);
                usr.removeAllRole();
                for(int y=0;y<roles.length;y++)
                {
                    Role role=rep.getRole(roles[y]);
                    usr.addRole(role);
                }
                usr.removeAllUserGroup();
                for(int y=0;y<userg.length;y++)
                {
                    UserGroup ug=rep.getUserGroup(userg[y]);
                    usr.addUserGroup(ug);
                }
            }
        }else if(action.equals("da"))
        {
            for(int x=0;x<users.length;x++)
            {
                User usr=rep.getUser(users[x]);
                usr.removeAllRole();
            }
        }else if(action.equals("ds") && roles!=null)
        {
            for(int x=0;x<users.length;x++)
            {
                User usr=rep.getUser(users[x]);
                for(int y=0;y<roles.length;y++)
                {
                    Role role=rep.getRole(roles[y]);
                    usr.removeRole(role);
                }
            }
        }else if(action.equals("as") && roles!=null)
        {
            for(int x=0;x<users.length;x++)
            {
                User usr=rep.getUser(users[x]);
                for(int y=0;y<roles.length;y++)
                {
                    Role role=rep.getRole(roles[y]);
                    usr.addRole(role);
                }
            }
        }else if(action.equals("os") && roles!=null)
        {
            for(int x=0;x<users.length;x++)
            {
                User usr=rep.getUser(users[x]);
                usr.removeAllRole();
                for(int y=0;y<roles.length;y++)
                {
                    Role role=rep.getRole(roles[y]);
                    usr.addRole(role);
                }
            }
        }else if(action.equals("dag"))
        {
            for(int x=0;x<users.length;x++)
            {
                User usr=rep.getUser(users[x]);
                usr.removeAllUserGroup();
            }
        }else if(action.equals("dsg") && userg!=null)
        {
            for(int x=0;x<users.length;x++)
            {
                User usr=rep.getUser(users[x]);
                for(int y=0;y<userg.length;y++)
                {
                    UserGroup ug=rep.getUserGroup(userg[y]);
                    usr.removeUserGroup(ug);
                }
            }
        }else if(action.equals("asg") && userg!=null)
        {
            for(int x=0;x<users.length;x++)
            {
                User usr=rep.getUser(users[x]);
                for(int y=0;y<userg.length;y++)
                {
                    UserGroup ug=rep.getUserGroup(userg[y]);
                    usr.addUserGroup(ug);
                }
            }
        }else if(action.equals("osg") && userg!=null)
        {
            for(int x=0;x<users.length;x++)
            {
                User usr=rep.getUser(users[x]);
                usr.removeAllUserGroup();;
                for(int y=0;y<userg.length;y++)
                {
                    UserGroup ug=rep.getUserGroup(userg[y]);
                    usr.addUserGroup(ug);
                }
            }
        }
%>
<script type="text/javascript">
showStatus('Acción realizada correctamente...');
</script>
<%
//        return;
    }
    
%>

<style type="text/css">    
    
    .dijitContentPaneSingleChild 
    {
        overflow: auto;
    } 

    .labels {
        width: 100px;
        text-align: right;
        padding-right: 5px;
    }    
    
    #uf_select, #uf_select2, 
    #ur_select, #ur_select2,
    #ug_select, #ug_select2 
    {
        width:220px;
        height:200px;
        overflow:auto;
    }
    
    div#uf_sel1, div#uf_sel2, div#uf_sel3, 
    div#ur_sel1, div#ur_sel2, div#ur_sel3,
    div#ug_sel1, div#ug_sel2, div#ug_sel3
    {
        float: left;
    }
    
    div#uf_leftRightButtons, 
    div#ur_leftRightButtons,
    div#ug_leftRightButtons
    {
        float: left;
        padding: 10em 0.5em 0 0.5em;
    }
    
    .button_left
    {
        width: 210px;
        text-align: left;        
    }
    .button_text
    {
        float: left;    
    }
    
    .iconMinus, .iconPlus, .iconEqual 
    {
        float: left;
        padding-right: 5px;
    }    
    
    .iconMinus 
    {
        color: red;
        font-size: 25px;
        margin-top: -8px;
        margin-bottom: -5px;
    }    
    
    .iconPlus
    {
        color: green;
        font-size: 20px;
        margin-top: -5px;
        margin-bottom: -5px;
    }   
    
    .iconEqual
    {
        color: blue;
        font-size: 20px;
        margin-top: -5px;
        margin-bottom: -5px;
    }       
</style>

<form id="userFilter_form" dojoType="dijit.form.Form" class="swbform" action="<%=path%>"  onsubmit="submitForm('userFilter_form'); return false;" method="post">
    <input id="uf_act" name="uf_act" type="hidden"/> 
    <fieldset>
        <table>
            <tr>
                <td class="labels"><label for="userRep">Repositorio de Usuarios:</label></td>
                <td>
                    <select id="uf_userRep" name="userRep" dojoType="dijit.form.FilteringSelect" onchange="submitForm('userFilter_form')" autoComplete="true" invalidMessage="Dato invalido." value="<%=userRep%>" >
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
                <td class="labels"><label for="userRep">Buscar por ID o Nombre de Usuario:</label></td>
                <td>
                    <input id="uf_search" type="text" dojoType="dijit.form.TextBox"> &nbsp; 
                    <button dojoType="dijit.form.Button" onclick="
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
                <td class="labels">
                    <label>Usuarios:</label>
                </td>                
                <td> 
                    <div>
                        <div id="uf_sel1">
                            <label for="allusers">Lista de Usuarios:</label><br>
                            <select multiple="true" dojoType="dijit.form.MultiSelect" id="uf_select">                                
                            </select>
                        </div>
                        <div id="uf_leftRightButtons">
                            <span>
                                <button dojoType="dijit.form.Button"  onclick="dijit.byId('uf_select').addSelected(dijit.byId('uf_select2'));return false;" title="Mover elementos a la primera lista">&lt;</button>
                                <button dojoType="dijit.form.Button"  onclick="dijit.byId('uf_select2').addSelected(dijit.byId('uf_select'));return false;" title="Mover elementos a la seguna lista">&gt;</button>
                            </span>
                        </div>
                        <div id="uf_sel2">
                            <label for="users">Usuarios seleccionados:</label><br>
                            <select multiple="true" name="users" dojoType="dijit.form.MultiSelect" id="uf_select2">
                            </select>
                        </div>
                        <div id="uf_sel3">
                            <br/>&nbsp;&nbsp;<button dojoType="dijit.form.Button" name="dal" onclick="dojo.byId('uf_act').value=this.value" type="submit" value="dal" title="Eliminar asignacion de todos los roles y grupos del los usuarios seleccionados"><div class="button_left"><div class="iconMinus">-</div> <div class="button_text">Todos los Roles y Grupos</div></div></button>
                            <br/>&nbsp;&nbsp;<button dojoType="dijit.form.Button" name="da" onclick="dojo.byId('uf_act').value=this.value" type="submit" value="da" title="Eliminar asignacion de todos los roles del los usuarios seleccionados"><div class="button_left"><div class="iconMinus">-</div> <div class="button_text">Todos los Roles</div></div></button>
                            <br/>&nbsp;&nbsp;<button dojoType="dijit.form.Button" name="dag" onclick="dojo.byId('uf_act').value=this.value" type="submit" value="dag" title="Eliminar asignacion de todos los grupos del los usuarios seleccionados"><div class="button_left"><div class="iconMinus">-</div> <div class="button_text">Todos los Grupos</div></div></button>
                            <br/>
                            <br/>&nbsp;&nbsp;<button dojoType="dijit.form.Button" name="dsl" onclick="dojo.byId('uf_act').value=this.value" type="submit" value="dsl" title="Eliminar asignación de los roles y grupos seleccionados"><div class="button_left"><div class="iconMinus">-</div> <div class="button_text">Roles y Grupos seleccionados</div></div></button>
                            <br/>&nbsp;&nbsp;<button dojoType="dijit.form.Button" name="asl" onclick="dojo.byId('uf_act').value=this.value" type="submit" value="asl" title="Agregar asignación de los roles y grupos seleccionados"><div class="button_left"><div class="iconPlus">+</div> <div class="button_text">Roles y Grupos seleccionados</div></div></button>
                            <br/>&nbsp;&nbsp;<button dojoType="dijit.form.Button" name="osl" onclick="dojo.byId('uf_act').value=this.value" type="submit" value="osl" title="Asignar solo los roles y grupos seleccionados"><div class="button_left"><div class="iconEqual">=</div> <div class="button_text">Roles y Grupos seleccionados</div></div></button>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="labels">
                    <label>Roles:</label>
                </td>                
                <td> 
                    <div>
                        <div id="ur_sel1">
                            <label for="allusers">Lista de Roles:</label><br>
                            <select multiple="true" dojoType="dijit.form.MultiSelect" id="ur_select">     
                        <%
                            if(userRep!=null)
                            {
                                Iterator<Role> it2 = UserRepository.ClassMgr.getUserRepository(userRep).listRoles();
                                while (it2.hasNext())
                                {
                                    Role ur = it2.next();
                                    String selected = "";
                                    //if (ur.getId().equals(userRep))
                                    //{
                                    //    selected = "selected=\"selected\"";
                                    //}
                        %>
                        <option value="<%=ur.getId()%>" <%=selected%>><%=ur.getDisplayTitle(lang)%></option>
                        <%
                                }
                            }
                        %>                                
                            </select>
                        </div>
                        <div id="ur_leftRightButtons">
                            <span>
                                <button dojoType="dijit.form.Button"  onclick="dijit.byId('ur_select').addSelected(dijit.byId('ur_select2'));return false;" title="Mover elementos a la primera lista">&lt;</button>
                                <button dojoType="dijit.form.Button"  onclick="dijit.byId('ur_select2').addSelected(dijit.byId('ur_select'));return false;" title="Mover elementos a la seguna lista">&gt;</button>
                            </span>
                        </div>
                        <div id="ur_sel2">
                            <label for="users">Roles seleccionados:</label><br>
                            <select multiple="true" name="roles" dojoType="dijit.form.MultiSelect" id="ur_select2">
                            </select>
                        </div>
                        <div id="ur_sel3">
                            <br/>&nbsp;&nbsp;<button dojoType="dijit.form.Button" name="ds" onclick="dojo.byId('uf_act').value=this.value" type="submit" value="ds" title="Eliminar asignación de los roles seleccionados"><div class="button_left"><div class="iconMinus">-</div> <div class="button_text">Roles seleccionados</div></div></button>
                            <br/>&nbsp;&nbsp;<button dojoType="dijit.form.Button" name="as" onclick="dojo.byId('uf_act').value=this.value" type="submit" value="as" title="Agregar asignación de los roles seleccionados"><div class="button_left"><div class="iconPlus">+</div> <div class="button_text">Roles seleccionados</div></div></button>
                            <br/>&nbsp;&nbsp;<button dojoType="dijit.form.Button" name="os" onclick="dojo.byId('uf_act').value=this.value" type="submit" value="os" title="Asignar solo los roles seleccionados"><div class="button_left"><div class="iconEqual">=</div> <div class="button_text">Roles seleccionados</div></div></button>
                        </div>
                    </div>
                </td>
            </tr>      
            <tr>
                <td class="labels">
                    <label>Grupos:</label>
                </td>                
                <td> 
                    <div>
                        <div id="ug_sel1">
                            <label for="userg">Lista de Grupos:</label><br>
                            <select multiple="true" dojoType="dijit.form.MultiSelect" id="ug_select">     
                        <%
                            if(userRep!=null)
                            {
                                Iterator<UserGroup> it2 = UserRepository.ClassMgr.getUserRepository(userRep).listUserGroups();
                                while (it2.hasNext())
                                {
                                    UserGroup ur = it2.next();
                                    String selected = "";
                                    //if (ur.getId().equals(userRep))
                                    //{
                                    //    selected = "selected=\"selected\"";
                                    //}
                        %>
                        <option value="<%=ur.getId()%>" <%=selected%>><%=ur.getDisplayTitle(lang)%></option>
                        <%
                                }
                            }
                        %>                                
                            </select>
                        </div>
                        <div id="ug_leftRightButtons">
                            <span>
                                <button dojoType="dijit.form.Button"  onclick="dijit.byId('ug_select').addSelected(dijit.byId('ug_select2'));return false;" title="Mover elementos a la primera lista">&lt;</button>
                                <button dojoType="dijit.form.Button"  onclick="dijit.byId('ug_select2').addSelected(dijit.byId('ug_select'));return false;" title="Mover elementos a la seguna lista">&gt;</button>
                            </span>
                        </div>
                        <div id="ug_sel2">
                            <label for="ug_select2">Grupos seleccionados:</label><br>
                            <select multiple="true" name="userg" dojoType="dijit.form.MultiSelect" id="ug_select2">
                            </select>
                        </div>
                        <div id="ug_sel3">
                            <br/>&nbsp;&nbsp;<button dojoType="dijit.form.Button" name="dsg" onclick="dojo.byId('uf_act').value=this.value" type="submit" value="dsg" title="Eliminar asignación de los grupos seleccionados"><div class="button_left"><div class="iconMinus">-</div> <div class="button_text">Grupos seleccionados</div></div></button>
                            <br/>&nbsp;&nbsp;<button dojoType="dijit.form.Button" name="asg" onclick="dojo.byId('uf_act').value=this.value" type="submit" value="asg" title="Agregar asignación de los grupos seleccionados"><div class="button_left"><div class="iconPlus">+</div> <div class="button_text">Grupos seleccionados</div></div></button>
                            <br/>&nbsp;&nbsp;<button dojoType="dijit.form.Button" name="osg" onclick="dojo.byId('uf_act').value=this.value" type="submit" value="osg" title="Asignar solo los grupos seleccionados"><div class="button_left"><div class="iconEqual">=</div> <div class="button_text">Grupos seleccionados</div></div></button>
                        </div>
                    </div>
                </td>
            </tr>              
        </table>
    </fieldset>
</form>

