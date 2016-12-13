import gov.stps.empleo.*
import org.semanticwb.model.SWBModel
import org.semanticwb.platform.SemanticProperty
import org.semanticwb.model.WebPage
import org.semanticwb.model.WebSite
import org.semanticwb.model.Resource
import org.semanticwb.model.ResourceType
import com.google.code.facebookapi.FacebookException;
import com.google.code.facebookapi.FacebookWebappHelper;
import com.google.code.facebookapi.FacebookXmlRestClient;
import com.google.code.facebookapi.IFacebookRestClient;

SWBModel model = org.semanticwb.model.SWBContext.getWebSite("empleo")
System.out.println("Modelo:  "+model)
def AE = gov.stps.empleo.Empresa.listEmpresas();
AE.each{
    println it
}
def api_key = "f5193e81d8840596eb930aee0768590d"
def secret = "869bbc6b8ba1d48944cda59bdcf59b83"

IFacebookRestClient<org.w3c.dom.Document> userClient = new FacebookXmlRestClient(api_key, secret);