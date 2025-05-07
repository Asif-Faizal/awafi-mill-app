class ApiConfig {
  static final String baseUrl = 'https://app.awafimill.com/api';
  // static final String baseUrl = 'https://testfro.adilc0070.site/api';
  
  // Stripe keys should be loaded from environment variables or secure storage
  // DO NOT commit actual keys to the repository
  static final String stripePublishableKey = String.fromEnvironment('STRIPE_PUBLISHABLE_KEY', defaultValue: '');
  static final String stripeSecretKey = String.fromEnvironment('STRIPE_SECRET_KEY', defaultValue: '');
}