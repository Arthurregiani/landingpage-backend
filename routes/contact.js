const { Router } = require('express');
const { body, validationResult } = require('express-validator');
const sendMail = require('../config/mailer');

const router = Router();

// Contact form validation rules
const contactValidation = [
  body('name')
    .trim()
    .notEmpty()
    .withMessage('Nome é obrigatório')
    .isLength({ min: 2, max: 100 })
    .withMessage('Nome deve ter entre 2 e 100 caracteres')
    .matches(/^[a-zA-ZÀ-ÿ\u0100-\u017F\u0180-\u024F\u0400-\u04FF\s'-]+$/)
    .withMessage('Nome contém caracteres inválidos'),
    
  body('email')
    .trim()
    .normalizeEmail()
    .isEmail()
    .withMessage('Email inválido')
    .isLength({ max: 254 })
    .withMessage('Email muito longo'),
    
  body('message')
    .trim()
    .notEmpty()
    .withMessage('Mensagem é obrigatória')
    .isLength({ min: 10, max: 2000 })
    .withMessage('Mensagem deve ter entre 10 e 2000 caracteres')
];

/**
 * POST /api/contact
 * Send contact form email
 */
router.post('/contact', contactValidation, async (req, res, next) => {
  try {
    // Check for validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Dados inválidos',
        errors: errors.array().map(error => ({
          field: error.path,
          message: error.msg,
          value: error.value
        }))
      });
    }

    const { name, email, message } = req.body;
    
    // Log the attempt (without sensitive data)
    console.log(`📨 Nova tentativa de contato de: ${name} <${email}>`);

    // Send email
    const emailResult = await sendMail({ name, email, message });

    // Success response
    res.status(200).json({
      success: true,
      message: 'Mensagem enviada com sucesso! Retornaremos em breve.',
      messageId: emailResult.messageId
    });

  } catch (error) {
    console.error('❌ Erro ao processar formulário de contato:', error);
    
    // Pass error to global error handler
    error.status = 500;
    next(error);
  }
});

/**
 * GET /api/contact
 * Get contact endpoint info
 */
router.get('/contact', (req, res) => {
  res.status(200).json({
    endpoint: '/api/contact',
    method: 'POST',
    description: 'Endpoint para envio de mensagens do formulário de contato',
    required_fields: {
      name: 'string (2-100 caracteres)',
      email: 'string (email válido)',
      message: 'string (10-2000 caracteres)'
    },
    rate_limit: '100 requests per 15 minutes',
    example: {
      name: 'João Silva',
      email: 'joao@exemplo.com',
      message: 'Olá! Gostaria de saber mais sobre seus serviços.'
    }
  });
});

module.exports = router;