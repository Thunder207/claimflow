const TRANSLATIONS = {
  en: {
    // ===== LOGIN PAGE =====
    login_title: "💼 <span style='font-weight:800; font-size:48px; letter-spacing:-1px;'><span style='color:#FBBF24;'>Claim</span><span style='color:#FFFFFF;'>Flow</span></span>",
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
    admin_title: "🏛️ <span style='font-weight:800; font-size:24px; letter-spacing:-0.5px;'><span style='color:#FBBF24;'>Claim</span><span style='color:#FFFFFF;'>Flow</span></span>",
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
    french: "FR",
    
    // ===== EMPLOYEE DASHBOARD - ADDITIONAL TRANSLATIONS =====
    
    // Header and navigation
    my_expenses: "My Expenses",
    notifications: "Notifications",
    notification_bell: "Notifications",
    no_notifications: "No notifications",
    
    // Tab navigation
    expenses: "Expenses",
    trips: "Trips",
    history: "History",
    
    // Expenses section
    add_expense: "Add Expense",
    standalone_expenses_guide: "Standalone Expenses — for items not tied to a business trip.",
    added_to_draft: "Added to draft!",
    error_message: "Error",
    expense_category: "Expense Category",
    choose_category: "Choose category...",
    transport: "Transport",
    phone_telecom: "Phone/Telecom", 
    office_supplies: "Office Supplies",
    professional_development: "Professional Development",
    parking: "Parking",
    internet: "Internet",
    other: "Other",
    vendor_details: "Vendor/Details",
    description_optional: "Description (Optional)",
    receipt_photo: "Receipt Photo",
    add_to_draft: "Add to Draft",
    
    // Draft expenses
    draft_expenses: "Draft Expenses",
    submit_all_approval: "Submit All for Approval",
    clear_all: "Clear All",
    expense_submitted_successfully: "Expense submitted successfully!",
    something_went_wrong: "Something went wrong",
    
    // Trip selection and expenses
    select_trip: "-- Select a trip --",
    create_new_trip: "✈️ Create New Trip",
    refresh: "🔄 Refresh",
    what_expense_type: "What type of expense is this?",
    choose_expense_type: "Choose your expense type...",
    breakfast_rate: "Breakfast - $23.45",
    lunch_rate: "Lunch - $29.75", 
    dinner_rate: "Dinner - $47.05",
    incidentals_rate: "Incidentals - $32.08",
    vehicle_km: "Vehicle (per km) - $0.68",
    hotel_receipt_required: "Hotel (Receipt Required) - No Limit",
    other_expense_custom: "Other Expense (Custom Amount)",
    
    // Hotel fields
    checkin_date: "Check-in Date",
    checkout_date: "Check-out Date",
    
    // Location and details
    city_province: "City, Province",
    establishment_name: "Establishment Name",
    additional_notes: "Additional notes",
    upload_receipt: "Upload Receipt",
    
    // Action buttons
    submit_expense: "Submit Expense",
    create_trip: "Create Trip",
    
    // Trip creation modal
    trip_creation: "Trip Creation",
    close: "Close",
    
    // History section
    submitted_expenses: "Submitted Expenses",
    filter_placeholder: "Filter by expense type, status, vendor, or amount...",
    no_submitted_expenses: "No submitted expenses yet.",
    start_by_submitting: "Start by submitting some expenses above!",
    
    // Status badges
    status_submitted: "Submitted",
    status_approved: "Approved", 
    status_rejected: "Rejected",
    status_pending: "Pending",
    
    // ===== ADMIN DASHBOARD - ADDITIONAL TRANSLATIONS =====
    
    // Role descriptions
    admin_role_desc: "Admin: All employees, all expenses, full management",
    supervisor_role_desc: "Supervisor: Your team only, approval powers",
    
    // Section titles
    all_expenses_admin_view: "All Expenses (Admin View)",
    team_expenses_supervisor_view: "Team Expenses (Supervisor View)",
    
    // Search and filters
    search_label: "Search:",
    search_expenses_placeholder: "Filter by employee name, expense type, status, or vendor...",
    loading_expenses: "Loading expenses...",
    
    // Employee management
    managing_employees: "Managing Employees",
    admin_help_text: "View and manage all employees in the system. Add new employees, edit details, and organize reporting structure.",
    supervisor_help_text: "View your direct reports and their information. Contact admin to make changes.",
    add_new_employee: "Add New Employee", 
    full_name: "Full Name",
    employee_number: "Employee Number",
    position: "Position",
    department: "Department",
    reports_to: "Reports To",
    no_supervisor: "No Supervisor",
    
    // Form actions
    save_employee: "Save Employee",
    cancel_action: "Cancel",
    
    // Loading states
    loading_employees: "Loading employees...",
    
    // Organization chart
    organization_chart: "Organization Chart",
    
    // NJC Rates section
    njc_travel_rates: "NJC Travel Rates",
    njc_desc: "Current National Joint Council per diem rates for travel expenses",
    last_updated: "Last updated",
    
    // Sage 300 section  
    sage300_integration: "Sage 300 Integration",
    sage300_desc: "Integration with Sage 300 ERP system for financial reporting",
    
    // ===== FORM VALIDATION AND MESSAGES =====
    
    // Required field messages
    field_required_asterisk: "*",
    amount_dollar: "Amount ($)",
    required_field: "*",
    
    // Placeholders
    trip_name_placeholder: "e.g., Montreal Business Meeting", 
    purpose_placeholder: "e.g., Client presentation and contract negotiation",
    amount_placeholder_zero: "0.00",
    city_province_placeholder: "City, Province",
    restaurant_hotel_placeholder: "Restaurant/Hotel name",
    additional_details_placeholder: "Additional details about the expense",
    
    // ===== COMMON UI ELEMENTS =====
    
    // Numbers and symbols
    dollar_sign: "$",
    percentage_sign: "%",
    dash_placeholder: "-",
    
    // Time and dates
    today: "Today",
    yesterday: "Yesterday",
    this_week: "This week",
    this_month: "This month",
    
    // Additional missing keys
    add_expense_to_trip: "Add Expense to Trip",
    approved: "Approved",
    brief_description_placeholder: "Brief description of the expense..."
  },
  
  fr: {
    // ===== PAGE DE CONNEXION =====
    login_title: "💼 <span style='font-weight:800; font-size:48px; letter-spacing:-1px;'><span style='color:#FBBF24;'>Claim</span><span style='color:#FFFFFF;'>Flow</span></span>",
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
    admin_title: "🏛️ <span style='font-weight:800; font-size:24px; letter-spacing:-0.5px;'><span style='color:#FBBF24;'>Claim</span><span style='color:#FFFFFF;'>Flow</span></span>",
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
    french: "FR",
    
    // ===== TABLEAU DE BORD EMPLOYÉ - TRADUCTIONS SUPPLÉMENTAIRES =====
    
    // En-tête et navigation
    my_expenses: "Mes dépenses",
    notifications: "Notifications",
    notification_bell: "Notifications",
    no_notifications: "Aucune notification",
    
    // Navigation par onglets
    expenses: "Dépenses",
    trips: "Voyages", 
    history: "Historique",
    
    // Section des dépenses
    add_expense: "Ajouter une dépense",
    standalone_expenses_guide: "Dépenses autonomes — pour les articles non liés à un voyage d'affaires.",
    added_to_draft: "Ajouté au brouillon !",
    error_message: "Erreur",
    expense_category: "Catégorie de dépense",
    choose_category: "Choisir une catégorie...",
    transport: "Transport",
    phone_telecom: "Téléphone/Télécom",
    office_supplies: "Fournitures de bureau",
    professional_development: "Perfectionnement professionnel", 
    parking: "Stationnement",
    internet: "Internet",
    other: "Autre",
    vendor_details: "Fournisseur/Détails",
    description_optional: "Description (Facultative)",
    receipt_photo: "Photo du reçu",
    add_to_draft: "Ajouter au brouillon",
    
    // Brouillons de dépenses
    draft_expenses: "Brouillons de dépenses",
    submit_all_approval: "Soumettre tout pour approbation",
    clear_all: "Effacer tout",
    expense_submitted_successfully: "Dépense soumise avec succès !",
    something_went_wrong: "Quelque chose a mal fonctionné",
    
    // Sélection de voyage et dépenses
    select_trip: "-- Sélectionner un voyage --",
    create_new_trip: "✈️ Créer un nouveau voyage",
    refresh: "🔄 Actualiser",
    what_expense_type: "Quel type de dépense est-ce ?",
    choose_expense_type: "Choisissez votre type de dépense...",
    breakfast_rate: "Petit-déjeuner - 23,45 $",
    lunch_rate: "Déjeuner - 29,75 $",
    dinner_rate: "Dîner - 47,05 $", 
    incidentals_rate: "Faux frais - 32,08 $",
    vehicle_km: "Véhicule (par km) - 0,68 $",
    hotel_receipt_required: "Hôtel (Reçu requis) - Aucune limite",
    other_expense_custom: "Autre dépense (Montant personnalisé)",
    
    // Champs d'hôtel
    checkin_date: "Date d'arrivée",
    checkout_date: "Date de départ",
    
    // Lieu et détails
    city_province: "Ville, Province",
    establishment_name: "Nom de l'établissement",
    additional_notes: "Notes supplémentaires",
    upload_receipt: "Télécharger le reçu",
    
    // Boutons d'action
    submit_expense: "Soumettre la dépense",
    create_trip: "Créer le voyage",
    
    // Modal de création de voyage
    trip_creation: "Création de voyage",
    close: "Fermer",
    
    // Section historique
    submitted_expenses: "Dépenses soumises",
    filter_placeholder: "Filtrer par type de dépense, statut, fournisseur ou montant...",
    no_submitted_expenses: "Aucune dépense soumise pour le moment.",
    start_by_submitting: "Commencez par soumettre quelques dépenses ci-dessus !",
    
    // Badges de statut
    status_submitted: "Soumis",
    status_approved: "Approuvé",
    status_rejected: "Rejeté", 
    status_pending: "En attente",
    
    // ===== TABLEAU DE BORD ADMIN - TRADUCTIONS SUPPLÉMENTAIRES =====
    
    // Descriptions des rôles
    admin_role_desc: "Admin : Tous les employés, toutes les dépenses, gestion complète",
    supervisor_role_desc: "Superviseur : Votre équipe seulement, pouvoirs d'approbation",
    
    // Titres de sections
    all_expenses_admin_view: "Toutes les dépenses (Vue administrateur)",
    team_expenses_supervisor_view: "Dépenses d'équipe (Vue superviseur)",
    
    // Recherche et filtres
    search_label: "Recherche :",
    search_expenses_placeholder: "Filtrer par nom d'employé, type de dépense, statut ou fournisseur...",
    loading_expenses: "Chargement des dépenses...",
    
    // Gestion des employés
    managing_employees: "Gestion des employés",
    admin_help_text: "Voir et gérer tous les employés du système. Ajouter de nouveaux employés, modifier les détails et organiser la structure hiérarchique.",
    supervisor_help_text: "Voir vos rapports directs et leurs informations. Contactez l'administrateur pour apporter des modifications.",
    add_new_employee: "Ajouter un nouvel employé",
    full_name: "Nom complet",
    employee_number: "Numéro d'employé",
    position: "Poste",
    department: "Département",
    reports_to: "Relève de",
    no_supervisor: "Aucun superviseur",
    
    // Actions de formulaire
    save_employee: "Enregistrer l'employé",
    cancel_action: "Annuler",
    
    // États de chargement
    loading_employees: "Chargement des employés...",
    
    // Organigramme
    organization_chart: "Organigramme",
    
    // Section des taux CNM
    njc_travel_rates: "Taux de voyage CNM",
    njc_desc: "Taux per diem actuels du Conseil national mixte pour les dépenses de voyage",
    last_updated: "Dernière mise à jour",
    
    // Section Sage 300
    sage300_integration: "Intégration Sage 300",
    sage300_desc: "Intégration avec le système ERP Sage 300 pour les rapports financiers",
    
    // ===== VALIDATION DE FORMULAIRE ET MESSAGES =====
    
    // Messages de champ obligatoire
    field_required_asterisk: "*",
    amount_dollar: "Montant ($)",
    required_field: "*",
    
    // Espaces réservés
    trip_name_placeholder: "p. ex., Réunion d'affaires à Montréal",
    purpose_placeholder: "p. ex., Présentation client et négociation de contrat",
    amount_placeholder_zero: "0,00",
    city_province_placeholder: "Ville, Province", 
    restaurant_hotel_placeholder: "Nom du restaurant/hôtel",
    additional_details_placeholder: "Détails supplémentaires sur la dépense",
    
    // ===== ÉLÉMENTS D'INTERFACE COMMUNS =====
    
    // Nombres et symboles
    dollar_sign: "$",
    percentage_sign: "%", 
    dash_placeholder: "-",
    
    // Temps et dates
    today: "Aujourd'hui",
    yesterday: "Hier",
    this_week: "Cette semaine",
    this_month: "Ce mois-ci",
    
    // Clés supplémentaires manquantes
    add_expense_to_trip: "Ajouter une dépense au voyage",
    approved: "Approuvé",
    brief_description_placeholder: "Brève description de la dépense..."
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
      // Use innerHTML for translations that contain HTML styling (like login_title, admin_title)
      if (key === 'login_title' || key === 'admin_title') {
        el.innerHTML = translation;
      } else {
        el.textContent = translation;
      }
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
  
  // Handle select options which can't use data-i18n directly
  updateSelectOptions();
  
  // Update any dynamic content
  updateDynamicContent();
}

function updateSelectOptions() {
  // Update standalone expense categories
  const saCategorySelect = document.getElementById('sa-category');
  if (saCategorySelect) {
    const options = saCategorySelect.querySelectorAll('option');
    options.forEach(option => {
      const value = option.value;
      switch(value) {
        case '':
          option.textContent = t('choose_category');
          break;
        case 'Transport':
          option.textContent = '🚗 ' + t('transport');
          break;
        case 'Phone/Telecom':
          option.textContent = '📱 ' + t('phone_telecom');
          break;
        case 'Office Supplies':
          option.textContent = '📝 ' + t('office_supplies');
          break;
        case 'Professional Development':
          option.textContent = '🎓 ' + t('professional_development');
          break;
        case 'Parking':
          option.textContent = '🅿️ ' + t('parking');
          break;
        case 'Internet':
          option.textContent = '🌐 ' + t('internet');
          break;
        case 'Other':
          option.textContent = '📋 ' + t('other');
          break;
      }
    });
  }
  
  // Update trip expense type options
  const expenseTypeSelect = document.getElementById('expense-type');
  if (expenseTypeSelect) {
    const options = expenseTypeSelect.querySelectorAll('option');
    options.forEach(option => {
      const value = option.value;
      switch(value) {
        case '':
          option.textContent = t('choose_expense_type');
          break;
        case 'breakfast':
          option.textContent = '🥐 ' + t('breakfast_rate');
          break;
        case 'lunch':
          option.textContent = '🥗 ' + t('lunch_rate');
          break;
        case 'dinner':
          option.textContent = '🍽️ ' + t('dinner_rate');
          break;
        case 'incidentals':
          option.textContent = '📱 ' + t('incidentals_rate');
          break;
        case 'vehicle_km':
          option.textContent = '🚗 ' + t('vehicle_km');
          break;
        case 'hotel':
          option.textContent = '🏨 ' + t('hotel_receipt_required');
          break;
        case 'other':
          option.textContent = '📝 ' + t('other_expense_custom');
          break;
      }
    });
  }
  
  // Update trip selection dropdown
  const tripSelect = document.getElementById('trip-select');
  if (tripSelect) {
    const firstOption = tripSelect.querySelector('option[value=""]');
    if (firstOption) {
      firstOption.textContent = t('select_trip');
    }
  }
  
  // Update admin role selector
  const roleSelect = document.getElementById('role-selector');
  if (roleSelect) {
    const options = roleSelect.querySelectorAll('option');
    options.forEach(option => {
      const value = option.value;
      switch(value) {
        case '':
          option.textContent = t('select_role');
          break;
        case 'admin':
          option.textContent = '🔧 ' + t('system_administrator');
          break;
        case 'supervisor':
          option.textContent = '👔 ' + t('supervisor_manager');
          break;
      }
    });
  }
  
  // Update supervisor selector
  const supervisorSelect = document.getElementById('supervisor-selector');
  if (supervisorSelect) {
    const firstOption = supervisorSelect.querySelector('option[value=""]');
    if (firstOption) {
      firstOption.textContent = t('select_name');
    }
  }
}

function updateDynamicContent() {
  // Update any content that needs special handling
  
  // Update role descriptions with proper formatting
  const roleDesc = document.querySelector('[data-i18n="role_descriptions"]');
  if (roleDesc) {
    roleDesc.innerHTML = `
      🔧 <strong>${t('admin_role_desc').split(':')[0]}:</strong> ${t('admin_role_desc').split(':')[1]}
      • 👔 <strong>${t('supervisor_role_desc').split(':')[0]}:</strong> ${t('supervisor_role_desc').split(':')[1]}
    `;
  }
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
