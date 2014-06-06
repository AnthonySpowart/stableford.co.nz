<% @Page Language="C#" Debug="true"%>
<% @Import Namespace="System.Web.Mail" %>
<%
if(Request.HttpMethod.ToUpper().Equals("POST"))
{
	string name = Request["Name"];
	string email = Request["Email"];
 	string enquiry = Request["Enquiry"];

	bool isValid = true;
	string message = "";
	if(String.IsNullOrEmpty(name))
	{
		isValid = false;
		message += "Name is missing<br>";
	}

	if(String.IsNullOrEmpty(email))
	{
		isValid = false;
		message += "Email is missing<br>";
	}

	if(String.IsNullOrEmpty(enquiry))
	{
		isValid = false;
		message += "Enquiry is missing<br>";
	}

	if(!isValid)
	{
		ReturnMessage(message,false);
		return;
	}
	else
	{
		string emailSubject = string.Format("Enquiry from Stableford.co.nz");
		string emailMessage = string.Format("Name: {0}\nEmail Address: {1}\nEnquiry: {2}\n", name, email, enquiry);

		System.Net.Mail.MailMessage mailMessage = new System.Net.Mail.MailMessage();
		mailMessage.Body = emailMessage;
		mailMessage.To.Add("stableford@xtra.co.nz");
		mailMessage.Subject = emailSubject;
		System.Net.Mail.SmtpClient SMTP = new System.Net.Mail.SmtpClient();
	
		try	
		{
			SMTP.Send(mailMessage);  
		} 
		catch (System.Exception ex)
		{
			ReturnMessage("Sorry your message could not be sent.", true);
		}

		ReturnMessage("Your message has been sent.", false);		
	}
}
%>

<script runat=server>
private void ReturnMessage(string message, bool isError)
{
	string messageType =  isError ? "error" : "message";
	string json = String.Format("{0}\"message\":\"{1}\", \"type\":\"{2}\" {3}", "{", message, messageType,"}");
	Response.Clear();
	Response.ContentType = "application/json; charset=utf-8";
	Response.Write(json);
	Response.End();
}
</script>