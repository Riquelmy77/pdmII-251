import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

main() async {
  // Configura as credenciais SMTP do Gmail
  final smtpServer = gmail('riquelmyquelmin@gmail.com', 'crcy arzp nekn rywj');

  // Cria uma mensagem de e-mail
  final message =
      Message()
        ..from = Address('riquelmyquelmin@gmail.com', 'Kelmas')
        ..recipients.add('riquelmy.ricarte08@aluno.ifce.edu.br')
        ..subject = 'Atividade do Taveira'
        ..text =
            'estou mandando esse email para realizar a avaliação-05 de pdmII, que precisa utilizar o SMTP para mandar email.';

  try {
    // Envia o e-mail usando o servidor SMTP do Gmail
    final sendReport = await send(message, smtpServer);

    // Exibe o resultado do envio do e-mail
    print('E-mail enviado: $sendReport');
  } on MailerException catch (e) {
    // Exibe informações sobre erros de envio de e-mail
    print('Erro ao enviar e-mail: ${e.toString()}');
  }
}
