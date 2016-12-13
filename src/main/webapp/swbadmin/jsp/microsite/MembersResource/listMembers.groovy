/**
 * SemanticWebBuilder es una plataforma para el desarrollo de portales y aplicaciones de integración,
 * colaboración y conocimiento, que gracias al uso de tecnología semántica puede generar contextos de
 * información alrededor de algún tema de interés o bien integrar información y aplicaciones de diferentes
 * fuentes, donde a la información se le asigna un significado, de forma que pueda ser interpretada y
 * procesada por personas y/o sistemas, es una creación original del Fondo de Información y Documentación
 * para la Industria INFOTEC, cuyo registro se encuentra actualmente en trámite.
 *
 * INFOTEC pone a su disposición la herramienta SemanticWebBuilder a través de su licenciamiento abierto al público (‘open source’),
 * en virtud del cual, usted podrá usarlo en las mismas condiciones con que INFOTEC lo ha diseñado y puesto a su disposición;
 * aprender de él; distribuirlo a terceros; acceder a su código fuente y modificarlo, y combinarlo o enlazarlo con otro software,
 * todo ello de conformidad con los términos y condiciones de la LICENCIA ABIERTA AL PÚBLICO que otorga INFOTEC para la utilización
 * del SemanticWebBuilder 4.0.
 *
 * INFOTEC no otorga garantía sobre SemanticWebBuilder, de ninguna especie y naturaleza, ni implícita ni explícita,
 * siendo usted completamente responsable de la utilización que le dé y asumiendo la totalidad de los riesgos que puedan derivar
 * de la misma.
 *
 * Si usted tiene cualquier duda o comentario sobre SemanticWebBuilder, INFOTEC pone a su disposición la siguiente
 * dirección electrónica:
 *  http://www.semanticwebbuilder.org
 **/

import org.semanticwb.portal.api.SWBParamRequest
import org.semanticwb.model.User
import org.semanticwb.model.WebPage
import org.semanticwb.portal.community.Member
import org.semanticwb.portal.community.MicroSite
import org.semanticwb.portal.community.MicroSiteWebPageUtil
import org.semanticwb.model.SWBModel
import org.semanticwb.SWBPlatform
import org.semanticwb.SWBPortal
import org.semanticwb.platform.SemanticProperty
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Calendar;


def paramRequest=request.getAttribute("paramRequest")
def String cssPath = SWBPortal.getWebWorkPath() + "/models/" + paramRequest.getWebPage().getWebSiteId() + "/css/images/";
User user = paramRequest.getUser()
WebPage wpage=paramRequest.getWebPage()
Member member = Member.getMember(user,wpage)
MicroSite microsite = null
if (wpage instanceof MicroSiteWebPageUtil) 
microsite = ((MicroSiteWebPageUtil)wpage).getMicroSite()
else if (wpage instanceof MicroSite)
microsite = wpage

if (null!=microsite){

    def ELEMENETS_BY_PAGE = 5;    
    def perfil = wpage.getWebSite().getWebPage("perfil").getRealUrl()
    def url=wpage.getUrl()
    println """
<div class="columnaIzquierda">
          """
    def elementos=0;
    Iterator<Member> lista = microsite.listMembers()
    while (lista.hasNext()){
        Member mem_curr = lista.next()
        elementos++
    }
    if(elementos==0)
    {
         println """<p>Esta comunidad no tiene miembros suscritos</p>"""
    }
    int paginas = elementos / ELEMENETS_BY_PAGE;
    if (elementos % ELEMENETS_BY_PAGE != 0)
    {
        paginas++;
    }
    int inicio = 0;
    int fin = ELEMENETS_BY_PAGE;
    int ipage = 1;
    if (request.getParameter("ipage") != null)
    {
        try
        {
            ipage = Integer.parseInt(request.getParameter("ipage"));
            inicio = (ipage * ELEMENETS_BY_PAGE) - ELEMENETS_BY_PAGE;
            fin = (ipage * ELEMENETS_BY_PAGE);
        }
        catch (NumberFormatException nfe)
        {
            ipage = 1;
        }
    }
    if (ipage < 1 || ipage > paginas)
    {
        ipage = 1;
    }
    if (inicio < 0)
    {
        inicio = 0;
    }
    if (fin < 0)
    {
        fin = ELEMENETS_BY_PAGE;
    }
    if (fin > elementos)
    {
        fin = elementos;
    }
    if (inicio > fin)
    {
        inicio = 0;
        fin = ELEMENETS_BY_PAGE;
    }
    if (fin - inicio > ELEMENETS_BY_PAGE)
    {
        inicio = 0;
        fin = ELEMENETS_BY_PAGE;
    }
    inicio++;
    if (paginas > 1)
    {
        println """<div class="paginacion">"""

        String nextURL = "#";
        String previusURL = "#";        
        if (ipage < paginas)
        {
            nextURL = paramRequest.getWebPage().getUrl() + "?ipage=" + (ipage + 1);
        }
        if (ipage > 1)
        {
            previusURL = paramRequest.getWebPage().getUrl() + "?ipage=" + (ipage - 1);
        }

        def imageurlleft=cssPath +"""pageArrowLeft.gif"""
        def imageurlright=cssPath +"""pageArrowRight.gif"""
        if(ipage>1)
        {
            println """<a href="$previusURL"><img src="$imageurlleft" alt="anterior"/></a>"""
        }
        for (int i = 1; i <= paginas; i++)
        {
            println """<a href="$url?ipage=$i">"""
            if(i==ipage)
            {
                println """<strong>"""
            }
            println """$i"""
            if(i==ipage)
            {
                println """</strong>"""
            }
            println """</a>"""
        }
        if(ipage!=paginas)
        {
            println """<a href="$nextURL"><img src="$imageurlright" alt="siguiente"/></a>"""
        }
        println """</div><!-- fin paginacion -->"""
    }
   
    
   
    //if (paramRequest.getCallMethod()==paramRequest.Call_STRATEGY && (!paramRequest.getArgument("virtualcontent").equals("true")))
    //if(true)
    //{
        def iElement = 0;
        lista = microsite.listMembers()
        while (lista.hasNext()){
            iElement++;
            Member mem_curr = lista.next()
            if (iElement > fin)
            {
                break;
            }
            if (iElement >= inicio && iElement <= fin)
            {
                User mem_usr = mem_curr.getUser()
                if (null!=mem_usr)
                {
                    def mapa = new HashMap()
                
                    Iterator<SemanticProperty> list = org.semanticwb.SWBPlatform.getSemanticMgr().getVocabulary().getSemanticClass("http://www.semanticwebbuilder.org/swb4/community#_ExtendedAttributes").listProperties();
                    list.each{
                        def sp = it
                        mapa.put(sp.getName(),sp)
                    }
                    def uri = mem_usr.getEncodedURI()

                    def img = SWBPortal.getContextPath() + "/swbadmin/jsp/microsite/perfil/profilePlaceholder.jpg"
                    if (mem_usr.getPhoto() != null)
                    {
                        img = SWBPortal.getWebWorkPath() + mem_usr.getPhoto()
                    }                    
                    def name=mem_usr.getFullName()
                    def usr_sex = mem_usr.getExtendedAttribute(mapa.get("userSex"))
                    if(usr_sex==null)usr_sex="";
                    if (usr_sex.equalsIgnoreCase("male"))
                    {
                        usr_sex = "Masculino";
                    }
                    else if (usr_sex.equalsIgnoreCase("female"))
                    {
                        usr_sex = "Femenino";
                    }
                    else
                    {
                        usr_sex = "";
                    }
                    

                    def usr_age = mem_usr.getExtendedAttribute(mapa.get("userBirthDate"))
                    if (null==usr_age)
                    {
                        usr_age = ""
                    }
                    if (!usr_age.equals(""))
                    {
                        def df = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss")
                        def date = df.parse(usr_age.toString());
                        java.util.Calendar cal1 = java.util.Calendar.getInstance()
                        cal1.setTime(date)

                        java.util.Calendar cal2 = java.util.Calendar.getInstance()
                        cal2.setTime(new Date(System.currentTimeMillis()))                        
                        usr_age = calcularEdad(cal1, cal2);
                    }
                    /*if((""+usr_age).equals("0"))
                    {
                        usr_age=""
                    } */

                    println """
                <div class="noticia">
                        <img src="$img" width="121" height="121" alt="Foto de $name"/>
                  <div class="noticiaTexto">
                        <h2>$name</h2>
                    <p class="stats">
                        Edad: $usr_age<br/><br/>
                        Sexo: $usr_sex<br/><br/>
                    <a href="$perfil?user=$uri">Ver m&aacute;s</a>
                    </p>                    
                    <br/><br/>
                  </div>
                </div>           
              
            """
                }
            }
       
        }    
        if (paginas > 1)
        {
            println """<div class="paginacion">"""
            String nextURL = "#";
            String previusURL = "#";
            if (ipage < paginas)
            {
                nextURL = paramRequest.getWebPage().getUrl() + "?ipage=" + (ipage + 1);
            }
            if (ipage > 1)
            {
                previusURL = paramRequest.getWebPage().getUrl() + "?ipage=" + (ipage - 1);
            }

            def imageurlleft=cssPath +"""pageArrowLeft.gif"""
            def imageurlright=cssPath +"""pageArrowRight.gif"""
            if(ipage>1)
            {
                println """
        <a href="$previusURL"><img src="$imageurlleft" alt="anterior"/></a>"""
            }
            for (int i = 1; i <= paginas; i++)
            {
                println """<a href="$url?ipage=$i">"""
                if(i==ipage)
                {
                    println """<strong>"""
                }
                println """$i"""
                if(i==ipage)
                {
                    println """</strong>"""
                }
                println """</a>"""
            }
            if(ipage!=paginas)
            {
                println """<a href="$nextURL"><img src="$imageurlright" alt="siguiente"/></a>"""
            }
            println """</div><!-- fin paginacion -->"""
        }
       
        println """
</div >
      <div class="columnaCentro">      	
      </div> """
    //}
}
def calcularEdad( fechaNaci, fechaAlta){    
        def int diff_ano =fechaAlta.get(Calendar.YEAR)-fechaNaci.get(Calendar.YEAR)
        def int diff_mes = fechaAlta.get(Calendar.MONTH)- fechaNaci.get(Calendar.MONTH)
        def int diff_dia = fechaAlta.get(Calendar.DATE)-fechaNaci.get(Calendar.DATE)
        if(diff_mes<0 ||(diff_mes==0 && diff_dia<0)){
            diff_ano =diff_ano-1
        }
        return diff_ano
    }
