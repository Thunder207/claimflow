const TRANSLATIONS = {
  en: {
    // ===== LOGIN PAGE =====
    login_title: "ClaimFlow",
    login_subtitle: "NJC-Compliant Expense Management",
    login_email: "Email Address",
    login_password: "Password",
    login_button: "🔐 Login to Dashboard",
    login_demo: "👥 Demo Accounts (Click to Login)",
    gov_badge: "🇨🇦 Government of Canada",
    email_placeholder: "your.name@company.com",
    password_placeholder: "Enter your password",
    
    // Demo accounts
    demo_john_admin: "🔧 John Smith - System Admin",
    demo_sarah_supervisor: "👔 Sarah Johnson - Supervisor (Finance)",
    demo_lisa_supervisor: "👔 Lisa Brown - Supervisor (Operations)",
    demo_mike_employee: "👤 Mike Davis - Employee (Finance)",
    demo_david_employee: "👤 David Wilson - Employee (Operations)",
    demo_anna_employee: "👤 Anna Lee - Employee (Operations)",
    
    // Login messages
    login_loading: "Logging you in...",
    login_error_invalid: "Invalid email or password",
    login_error_email_required: "Email address is required",
    login_error_email_invalid: "Please enter a valid email address",
    login_error_email_long: "Email address is too long",
    login_error_password_required: "Password is required",
    login_error_password_long: "Password is too long",
    login_error_rate_limit: "Too many login attempts. Please wait a moment and try again.",
    login_error_server: "Server error. Please try again in a few minutes.",
    login_error_storage: "Unable to save login session. Please check your browser settings.",
    login_error_network: "Network error. Please check your connection and try again.",
    login_error_timeout: "Login request timed out. Please check your internet connection and try again.",
    login_success: "Login successful! Redirecting...",
    login_welcome_back: "Welcome back",
    
    // ===== NAVIGATION & COMMON =====
    logout: "🚪 Logout",
    employee_portal: "← Employee Portal",
    supervisor_view: "Switch to Supervisor View",
    export_csv: "📥 Export CSV",
    back: "← Back",
    save: "Save",
    cancel: "Cancel",
    delete: "Delete",
    edit: "Edit",
    search: "🔍 Search",
    clear: "Clear",
    no_results: "No results found",
    loading: "Loading...",
    error_occurred: "An error occurred",
    success: "Success",
    
    // ===== EMPLOYEE DASHBOARD =====
    dashboard_title: "Employee Expense Dashboard",
    welcome_employee: "Welcome",
    dashboard_subtitle: "Track and submit your business expenses",
    
    // Dashboard tabs
    individual_expenses: "📋 Individual Expenses",
    trip_expenses: "✈️ Trip Expenses", 
    draft_expenses: "📝 Draft Expenses",
    submit_expense: "📝 Submit Expense",
    my_trips: "🧳 My Trips",
    expense_history: "📋 Expense History",
    
    // Trip creation
    create_trip: "✈️ Create New Trip",
    trip_name: "Trip Name",
    start_date: "Start Date",
    end_date: "End Date",
    destination: "Destination",
    purpose: "Purpose",
    create_trip_button: "Create Trip",
    trip_placeholder: "e.g., Montreal Business Meeting",
    purpose_placeholder: "e.g., Client presentation and contract negotiation",
    
    // Expense form
    expense_type: "Expense Type",
    select_type: "Select expense type",
    breakfast: "Breakfast",
    lunch: "Lunch",
    dinner: "Dinner",
    hotel: "Hotel/Accommodation",
    vehicle: "Private Vehicle",
    incidentals: "Incidentals",
    amount: "Amount",
    date: "Date",
    location: "Location",
    vendor: "Vendor/Establishment",
    description: "Description",
    receipt: "Receipt/Invoice",
    add_expense: "Add Expense",
    add_expense_to_trip: "Add Expense to Trip",
    submit_trip: "Submit Trip for Approval",
    
    // Form placeholders
    amount_placeholder: "0.00",
    location_placeholder: "City, Province",
    vendor_placeholder: "Restaurant/Hotel name",
    description_placeholder: "Additional details about the expense",
    
    // Status labels
    draft: "Draft",
    submitted: "Submitted",
    pending: "Pending",
    approved: "Approved",
    rejected: "Rejected",
    returned: "Returned for Correction",
    
    // Statistics
    total_amount: "Total Amount",
    approved_amount: "Approved Amount",
    pending_approval: "Pending Approval",
    total_expenses: "Total Expenses",
    
    // ===== ADMIN DASHBOARD =====
    admin_title: "🏛️ ClaimFlow",
    admin_subtitle: "Comprehensive expense tracking and approval dashboard",
    sys_admin: "System Administrator",
    choose_dashboard_view: "👤 Choose Your Dashboard View",
    dashboard_view_desc: "Different roles see different data and have different capabilities",
    role_descriptions: "🔧 Admin: All employees, all expenses, full management • 👔 Supervisor: Your team only, approval powers",
    select_role: "Select Your Role...",
    system_administrator: "🔧 System Administrator",
    supervisor_manager: "👔 Supervisor/Manager",
    choose_supervisor: "Choose your name to see your team:",
    select_name: "Select Your Name...",
    
    // Admin tabs
    expenses_tab: "📊 Expenses Dashboard",
    employees_tab: "👥 Employee Directory",
    org_chart: "🏢 Organization Chart",
    sage_tab: "💰 Sage 300",
    njc_tab: "📋 NJC Rates",
    
    // Admin sections
    all_expenses_admin: "📊 All Expenses (Admin View)",
    all_expenses_supervisor: "📊 Team Expenses (Supervisor View)",
    expenses_for: "📊 Expenses for",
    search_expenses: "Filter by employee name, expense type, status, or vendor...",
    search_description: "Search across employee names, expense types (meal types), approval status, vendors, and amounts",
    
    // Employee directory
    employee_directory: "👥 Employee Directory",
    all_employees: "All Employees in System",
    team_members: "Your Team Members",
    employees_under: "Employees under",
    total_employees: "Total Employees",
    
    // Actions
    approve: "Approve",
    reject: "Reject",
    return_correction: "Return for Correction",
    
    // Organization chart
    org_chart_title: "🏢 Organization Chart",
    org_chart_desc: "Visual representation of the reporting structure",
    
    // NJC Rates
    njc_rates_title: "📋 NJC Travel Rates",
    njc_rates_desc: "Current National Joint Council per diem rates for travel expenses",
    njc_rates_updated: "Last updated",
    
    // Sage 300 integration
    sage300_title: "💰 Sage 300 Integration",
    sage300_desc: "Integration with Sage 300 ERP system for financial reporting",
    
    // Messages and alerts
    loading_expenses: "Loading expenses...",
    loading_employees: "Loading employees...",
    no_expenses: "No expenses found",
    no_employees: "No employees found",
    
    // Validation messages
    field_required: "This field is required",
    invalid_amount: "Please enter a valid amount",
    invalid_email: "Please enter a valid email address",
    date_required: "Date is required",
    future_date_error: "Date cannot be in the future",
    
    // Success messages
    expense_added: "Expense added successfully",
    trip_created: "Trip created successfully",
    expense_updated: "Expense updated successfully",
    expense_deleted: "Expense deleted successfully",
    
    // Language toggle
    language: "Language",
    english: "EN",
    french: "FR"
  },
  
  fr: {
    // ===== PAGE DE CONNEXION =====
    login_title: "ClaimFlow",
    login_subtitle: "Gestion des dépenses conforme au CNM",
    login_email: "Adresse courriel",
    login_password: "Mot de passe",
    login_button: "🔐 Connexion au tableau de bord",
    login_demo: "👥 Comptes de démonstration (Cliquer pour se connecter)",
    gov_badge: "🇨🇦 Gouvernement du Canada",
    email_placeholder: "votre.nom@entreprise.com",
    password_placeholder: "Entrez votre mot de passe",
    
    // Comptes de démonstration
    demo_john_admin: "🔧 John Smith - Administrateur système",
    demo_sarah_supervisor: "👔 Sarah Johnson - Superviseure (Finances)",
    demo_lisa_supervisor: "👔 Lisa Brown - Superviseure (Opérations)",
    demo_mike_employee: "👤 Mike Davis - Employé (Finances)",
    demo_david_employee: "👤 David Wilson - Employé (Opérations)",
    demo_anna_employee: "👤 Anna Lee - Employée (Opérations)",
    
    // Messages de connexion
    login_loading: "Connexion en cours...",
    login_error_invalid: "Courriel ou mot de passe invalide",
    login_error_email_required: "L'adresse courriel est requise",
    login_error_email_invalid: "Veuillez entrer une adresse courriel valide",
    login_error_email_long: "L'adresse courriel est trop longue",
    login_error_password_required: "Le mot de passe est requis",
    login_error_password_long: "Le mot de passe est trop long",
    login_error_rate_limit: "Trop de tentatives de connexion. Veuillez attendre un moment et réessayer.",
    login_error_server: "Erreur serveur. Veuillez réessayer dans quelques minutes.",
    login_error_storage: "Impossible de sauvegarder la session. Veuillez vérifier les paramètres de votre navigateur.",
    login_error_network: "Erreur réseau. Veuillez vérifier votre connexion et réessayer.",
    login_error_timeout: "Délai de connexion dépassé. Veuillez vérifier votre connexion Internet et réessayer.",
    login_success: "Connexion réussie ! Redirection...",
    login_welcome_back: "Bon retour",
    
    // ===== NAVIGATION ET COMMUN =====
    logout: "🚪 Déconnexion",
    employee_portal: "← Portail de l'employé",
    supervisor_view: "Passer à la vue superviseur",
    export_csv: "📥 Exporter CSV",
    back: "← Retour",
    save: "Enregistrer",
    cancel: "Annuler",
    delete: "Supprimer",
    edit: "Modifier",
    search: "🔍 Rechercher",
    clear: "Effacer",
    no_results: "Aucun résultat trouvé",
    loading: "Chargement...",
    error_occurred: "Une erreur s'est produite",
    success: "Succès",
    
    // ===== TABLEAU DE BORD EMPLOYÉ =====
    dashboard_title: "Tableau de bord des dépenses",
    welcome_employee: "Bienvenue",
    dashboard_subtitle: "Suivez et soumettez vos dépenses d'affaires",
    
    // Onglets du tableau de bord
    individual_expenses: "📋 Dépenses individuelles",
    trip_expenses: "✈️ Dépenses de voyage",
    draft_expenses: "📝 Brouillons",
    submit_expense: "📝 Soumettre dépense",
    my_trips: "🧳 Mes voyages",
    expense_history: "📋 Historique des dépenses",
    
    // Création de voyage
    create_trip: "✈️ Créer un nouveau voyage",
    trip_name: "Nom du voyage",
    start_date: "Date de début",
    end_date: "Date de fin",
    destination: "Destination",
    purpose: "Objet",
    create_trip_button: "Créer le voyage",
    trip_placeholder: "p. ex., Réunion d'affaires à Montréal",
    purpose_placeholder: "p. ex., Présentation client et négociation de contrat",
    
    // Formulaire de dépenses
    expense_type: "Type de dépense",
    select_type: "Sélectionner le type de dépense",
    breakfast: "Petit-déjeuner",
    lunch: "Déjeuner",
    dinner: "Dîner",
    hotel: "Hôtel/Hébergement",
    vehicle: "Véhicule personnel",
    incidentals: "Faux frais",
    amount: "Montant",
    date: "Date",
    location: "Lieu",
    vendor: "Fournisseur/Établissement",
    description: "Description",
    receipt: "Reçu/Facture",
    add_expense: "Ajouter la dépense",
    add_expense_to_trip: "Ajouter la dépense au voyage",
    submit_trip: "Soumettre le voyage pour approbation",
    
    // Espaces réservés des formulaires
    amount_placeholder: "0,00",
    location_placeholder: "Ville, Province",
    vendor_placeholder: "Nom du restaurant/hôtel",
    description_placeholder: "Détails supplémentaires sur la dépense",
    
    // Étiquettes de statut
    draft: "Brouillon",
    submitted: "Soumis",
    pending: "En attente",
    approved: "Approuvé",
    rejected: "Rejeté",
    returned: "Retourné pour correction",
    
    // Statistiques
    total_amount: "Montant total",
    approved_amount: "Montant approuvé",
    pending_approval: "En attente d'approbation",
    total_expenses: "Total des dépenses",
    
    // ===== TABLEAU DE BORD ADMIN =====
    admin_title: "🏛️ ClaimFlow",
    admin_subtitle: "Tableau de bord complet de suivi et d'approbation des dépenses",
    sys_admin: "Administrateur système",
    choose_dashboard_view: "👤 Choisissez votre vue du tableau de bord",
    dashboard_view_desc: "Les différents rôles voient des données différentes et ont des capacités différentes",
    role_descriptions: "🔧 Admin : Tous les employés, toutes les dépenses, gestion complète • 👔 Superviseur : Votre équipe seulement, pouvoirs d'approbation",
    select_role: "Sélectionnez votre rôle...",
    system_administrator: "🔧 Administrateur système",
    supervisor_manager: "👔 Superviseur/Gestionnaire",
    choose_supervisor: "Choisissez votre nom pour voir votre équipe :",
    select_name: "Sélectionnez votre nom...",
    
    // Onglets admin
    expenses_tab: "📊 Tableau des dépenses",
    employees_tab: "👥 Répertoire des employés",
    org_chart: "🏢 Organigramme",
    sage_tab: "💰 Sage 300",
    njc_tab: "📋 Taux CNM",
    
    // Sections admin
    all_expenses_admin: "📊 Toutes les dépenses (Vue administrateur)",
    all_expenses_supervisor: "📊 Dépenses d'équipe (Vue superviseur)",
    expenses_for: "📊 Dépenses pour",
    search_expenses: "Filtrer par nom d'employé, type de dépense, statut ou fournisseur...",
    search_description: "Rechercher parmi les noms d'employés, types de dépenses (types de repas), statut d'approbation, fournisseurs et montants",
    
    // Répertoire des employés
    employee_directory: "👥 Répertoire des employés",
    all_employees: "Tous les employés du système",
    team_members: "Membres de votre équipe",
    employees_under: "Employés sous",
    total_employees: "Total des employés",
    
    // Actions
    approve: "Approuver",
    reject: "Rejeter",
    return_correction: "Retourner pour correction",
    
    // Organigramme
    org_chart_title: "🏢 Organigramme",
    org_chart_desc: "Représentation visuelle de la structure hiérarchique",
    
    // Taux CNM
    njc_rates_title: "📋 Taux de voyage CNM",
    njc_rates_desc: "Taux per diem actuels du Conseil national mixte pour les dépenses de voyage",
    njc_rates_updated: "Dernière mise à jour",
    
    // Intégration Sage 300
    sage300_title: "💰 Intégration Sage 300",
    sage300_desc: "Intégration avec le système ERP Sage 300 pour les rapports financiers",
    
    // Messages et alertes
    loading_expenses: "Chargement des dépenses...",
    loading_employees: "Chargement des employés...",
    no_expenses: "Aucune dépense trouvée",
    no_employees: "Aucun employé trouvé",
    
    // Messages de validation
    field_required: "Ce champ est requis",
    invalid_amount: "Veuillez entrer un montant valide",
    invalid_email: "Veuillez entrer une adresse courriel valide",
    date_required: "La date est requise",
    future_date_error: "La date ne peut pas être dans le futur",
    
    // Messages de succès
    expense_added: "Dépense ajoutée avec succès",
    trip_created: "Voyage créé avec succès",
    expense_updated: "Dépense mise à jour avec succès",
    expense_deleted: "Dépense supprimée avec succès",
    
    // Sélecteur de langue
    language: "Langue",
    english: "EN",
    french: "FR"
  }
};

// Translation utility functions
function t(key) {
  const lang = localStorage.getItem('claimflow_lang') || 'en';
  return TRANSLATIONS[lang][key] || TRANSLATIONS['en'][key] || key;
}

function setLanguage(lang) {
  localStorage.setItem('claimflow_lang', lang);
  applyTranslations();
  
  // Update URL language parameter if present
  const urlParams = new URLSearchParams(window.location.search);
  if (urlParams.has('lang')) {
    urlParams.set('lang', lang);
    const newUrl = window.location.pathname + '?' + urlParams.toString();
    window.history.replaceState(null, '', newUrl);
  }
  
  // Update language toggle buttons
  updateLanguageToggle();
}

function applyTranslations() {
  // Translate elements with data-i18n attribute
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.getAttribute('data-i18n');
    const translation = t(key);
    
    if (el.tagName === 'INPUT') {
      if (el.type === 'submit' || el.type === 'button') {
        el.value = translation;
      } else {
        el.placeholder = translation;
      }
    } else if (el.tagName === 'TEXTAREA') {
      el.placeholder = translation;
    } else {
      el.textContent = translation;
    }
  });
  
  // Update page title
  const titleKey = document.documentElement.getAttribute('data-title-key');
  if (titleKey) {
    document.title = t(titleKey);
  }
  
  // Custom translations that require special handling
  updateCustomTranslations();
}

function updateLanguageToggle() {
  const currentLang = localStorage.getItem('claimflow_lang') || 'en';
  const enBtn = document.getElementById('lang-en');
  const frBtn = document.getElementById('lang-fr');
  
  if (enBtn && frBtn) {
    enBtn.classList.toggle('active', currentLang === 'en');
    frBtn.classList.toggle('active', currentLang === 'fr');
  }
}

function updateCustomTranslations() {
  // Handle dynamic content that can't use data-i18n
  // This will be called by individual pages as needed
}

// Initialize language based on URL parameter or stored preference
function initializeLanguage() {
  const urlParams = new URLSearchParams(window.location.search);
  const urlLang = urlParams.get('lang');
  
  if (urlLang && (urlLang === 'en' || urlLang === 'fr')) {
    setLanguage(urlLang);
  } else {
    const storedLang = localStorage.getItem('claimflow_lang') || 'en';
    applyTranslations();
    updateLanguageToggle();
  }
}

// Auto-initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
  initializeLanguage();
});// v2
