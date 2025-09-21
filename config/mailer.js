const nodemailer = require('nodemailer');

// Create reusable transporter object using SMTP (supports Gmail, Proton Mail, etc.)
const transporter = nodemailer.createTransport({
  // Gmail configuration (if using Gmail)
  ...(process.env.SMTP_SERVICE === 'gmail' && { service: 'gmail' }),
  
  // Proton Mail configuration (if using Proton Mail)
  ...(process.env.SMTP_SERVICE === 'proton' && {
    host: 'mail.proton.me',
    port: 587,
    secure: false, // STARTTLS
  }),
  
  // Generic SMTP configuration (fallback)
  ...(!process.env.SMTP_SERVICE && {
    host: process.env.SMTP_HOST || 'mail.proton.me',
    port: parseInt(process.env.SMTP_PORT) || 587,
    secure: process.env.SMTP_SECURE === 'true' || false,
  }),
  
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS
  },
  
  // Additional security options
  tls: {
    rejectUnauthorized: true,
    ciphers: 'SSLv3'
  }
});

// Verify connection configuration
transporter.verify((error, success) => {
  if (error) {
    console.error('❌ Erro na configuração do email:', error.message);
  } else {
    console.log('✅ Servidor de email configurado com sucesso');
  }
});

/**
 * Send contact form email
 * @param {Object} formData - Form data containing name, email, and message
 * @param {string} formData.name - Sender's name
 * @param {string} formData.email - Sender's email
 * @param {string} formData.message - Message content
 * @returns {Promise} - Mail sending promise
 */
const sendContactEmail = async ({ name, email, message }) => {
  // Sanitize inputs to prevent header injection
  const sanitizedName = name.replace(/[\r\n]/g, '').trim();
  const sanitizedMessage = message.replace(/[\r\n]+/g, '\n').trim();
  
  // Create email template
  const emailContent = `
Nova mensagem recebida do site!

👤 Nome: ${sanitizedName}
📧 Email: ${email}
📝 Mensagem:
${sanitizedMessage}

---
Esta mensagem foi enviada através do formulário de contato do seu site.
Para responder, use o email: ${email}
  `.trim();

  const htmlContent = `
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
      <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 10px 10px 0 0;">
        <h2 style="margin: 0; font-size: 24px;">🎉 Nova mensagem do site!</h2>
      </div>
      
      <div style="background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; border: 1px solid #e9ecef;">
        <div style="margin-bottom: 20px;">
          <strong style="color: #495057; display: inline-block; width: 80px;">👤 Nome:</strong>
          <span style="color: #212529;">${sanitizedName}</span>
        </div>
        
        <div style="margin-bottom: 20px;">
          <strong style="color: #495057; display: inline-block; width: 80px;">📧 Email:</strong>
          <a href="mailto:${email}" style="color: #007bff; text-decoration: none;">${email}</a>
        </div>
        
        <div style="margin-bottom: 30px;">
          <strong style="color: #495057; display: block; margin-bottom: 10px;">📝 Mensagem:</strong>
          <div style="background: white; padding: 15px; border-radius: 8px; border-left: 4px solid #007bff; font-style: italic; line-height: 1.6;">
            ${sanitizedMessage.replace(/\n/g, '<br>')}
          </div>
        </div>
        
        <div style="border-top: 1px solid #dee2e6; padding-top: 20px; color: #6c757d; font-size: 14px;">
          <p style="margin: 0;">Esta mensagem foi enviada através do formulário de contato do seu site.</p>
          <p style="margin: 10px 0 0 0;">Para responder, clique <a href="mailto:${email}" style="color: #007bff;">aqui</a> ou use o email: ${email}</p>
        </div>
      </div>
    </div>
  `;

  const mailOptions = {
    from: `"Site - Novo Contato" <${process.env.SMTP_USER}>`,
    to: process.env.SMTP_TO,
    replyTo: email,
    subject: `💌 Nova mensagem de ${sanitizedName}`,
    text: emailContent,
    html: htmlContent,
    // Email headers for better deliverability
    headers: {
      'X-Priority': '3',
      'X-MSMail-Priority': 'Normal',
      'Importance': 'Normal'
    }
  };

  try {
    const info = await transporter.sendMail(mailOptions);
    console.log(`📧 Email enviado com sucesso: ${info.messageId}`);
    return info;
  } catch (error) {
    console.error('❌ Erro ao enviar email:', error);
    throw new Error(`Falha ao enviar email: ${error.message}`);
  }
};

module.exports = sendContactEmail;