<?php

namespace App\Controller;

use GuzzleHttp\Client;
use Symfony\Component\Mime\Email;
use Symfony\Component\Mime\Address;
use Symfony\Component\Mime\Part\DataPart;
use Symfony\Bridge\Twig\Mime\TemplatedEmail;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Mailer\MailerInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Mailer\Exception\TransportExceptionInterface;

class HOMEController extends AbstractController
{
    #[Route('/', name: 'app_h_o_m_e')]
    public function index(): Response
    {
        return $this->render('home/index.html.twig', [
            'controller_name' => 'HOMEController',
        ]);
    }

    #[Route('/mailer', name: 'app_mailer', methods: ['POST'])]
    public function indexmailer(Request $request,MailerInterface $mailer): Response
    {    $name = $request->request->get('name');
        $message =$request->request->get('message');
               $email1 = $request->request->get('email');
               $phone =$request->request->get('phone');
               $subject =$request->request->get('subject');

               $file = $request->files->get('file');
               $recaptchaResponse = $request->request->get('g-recaptcha-response');
               if (!$this->isRecaptchaValid($recaptchaResponse)) {
                // Handle invalid reCAPTCHA, e.g., show an error message or redirect
                $this->addFlash('error', 'Invalid reCAPTCHA. Please try again.');
            }
            
        // Create a TemplatedEmail
        $email = (new TemplatedEmail())
            ->from(new Address($email1, 'Your Name'))
            ->to(new Address('meriem.ibrahim@esprit.tn', 'Recipient Name'))
            ->subject('nouvelle Demande')
            ->htmlTemplate('mailer/index.html.twig') // Template path
            ->attachFromPath($file->getPathname(), $file->getClientOriginalName())
            ->addPart((new DataPart(fopen('images/logo-223x50.png', 'r'), 'logo', 'image/png'))->asInline())

            ->context([
                'name' => $name,
                'Message' => $message,
                'subject' => $subject,
                'email1' => $email1,

                'phone' => $phone,
            ]);
            

        // Attach the logo as an inline image with CID (Content-ID)

        // Send the email
        $mailer->send($email);

        $email2 = (new TemplatedEmail())
        ->from(new Address('meriem.ibrahim@esprit.tn', 'Your Name'))
        ->to(new Address($email1, 'Recipient Name'))
        ->subject('Vous Avez Postuler Chez MedicalMatch ')
        ->htmlTemplate('mailer/index1.html.twig') // Template path
        ->addPart((new DataPart(fopen('images/logo-223x50.png', 'r'), 'footer-signature', 'image/png'))->asInline())

        ->context([
            'name' => $name,
            'subject' => $subject,
            'email1' => $email1,

        ]);
        

    // Attach the logo as an inline image with CID (Content-ID)

    // Send the email
    $mailer->send($email2);

  ;
  $this->addFlash('success', 'VOTRE Demande  A ETE PASSE AVEC SUCCEE ');


  return $this->redirectToRoute('app_h_o_m_e');
}

#[Route('/Contacts', name: 'app_mailerr', methods: ['POST'])]
public function indexmailerr(Request $request,MailerInterface $mailer): Response
    {    $name = $request->request->get('name');
        $message =$request->request->get('message');
               $email1 = $request->request->get('email');
               $phone =$request->request->get('phone');
               $subject1 ="Message From Contacts";

             
            
        // Create a TemplatedEmail
        $email = (new TemplatedEmail())
            ->from(new Address($email1, 'Your Name'))
            ->to(new Address('meriem.ibrahim@esprit.tn', 'Recipient Name'))
            ->subject('nouveau Message De Contacts')
            ->htmlTemplate('mailer/index.html.twig') // Template path
            ->addPart((new DataPart(fopen('images/logo-223x50.png', 'r'), 'logo', 'image/png'))->asInline())

            ->context([
                'name' => $name,
                'Message' => $message,
                'subject' => $subject1,
                'email1' => $email1,

                'phone' => $phone,
            ]);
            

        // Attach the logo as an inline image with CID (Content-ID)

        // Send the email
        $mailer->send($email);

        $email2 = (new TemplatedEmail())
        ->from(new Address('meriem.ibrahim@esprit.tn', 'Your Name'))
        ->to(new Address($email1, 'Recipient Name'))
        ->subject('Votre Message est envoyée ')
        ->htmlTemplate('mailer/index2.html.twig') // Template path
        ->addPart((new DataPart(fopen('images/logo-223x50.png', 'r'), 'footer-signature', 'image/png'))->asInline())

        ->context([
            'name' => $name,
            'subject' => $subject1,
            'email1' => $email1,

        ]);
        

    // Attach the logo as an inline image with CID (Content-ID)

    // Send the email
    $mailer->send($email2);

  ;


  return $this->redirectToRoute('app_h_o_m_e', [], Response::HTTP_SEE_OTHER);
}

private function isRecaptchaValid(string $recaptchaResponse): bool
{
    $recaptchaSecretKey = '6LcCMsklAAAAAAprLCV19nrNyCFzQ9ONIsjTZI_4';
    $recaptchaVerifyUrl = "https://www.google.com/recaptcha/api/siteverify?secret={$recaptchaSecretKey}&response={$recaptchaResponse}";

    $response = file_get_contents($recaptchaVerifyUrl);
    $responseData = json_decode($response, true);

    return isset($responseData['success']) && $responseData['success'] === true;
}

}