class PagesController < ApplicationController
  def index
  end

  def contact
    # Render the contact page
  end

  def help_center
    # Main help center page
    @categories = help_categories
    @popular_articles = popular_articles
    @recent_articles = recent_articles
  end

  def help_category
    # Category page
    @category = params[:category]
    @categories = help_categories
    @current_category = @categories.find { |cat| cat[:slug] == @category }

    if @current_category.nil?
      redirect_to help_center_path
      return
    end

    @articles = @current_category[:articles]
  end

  def help_article
    # Article page
    @category = params[:category]
    @article_slug = params[:article]
    @categories = help_categories
    @current_category = @categories.find { |cat| cat[:slug] == @category }

    if @current_category.nil?
      redirect_to help_center_path
      return
    end

    @article = @current_category[:articles].find { |art| art[:slug] == @article_slug }

    if @article.nil?
      redirect_to help_category_path(@category)
      return
    end

    @related_articles = related_articles(@article)
  end

  def tutorials
    # Main tutorials page
    @featured_tutorial = tutorials_data.first
    @tutorials = tutorials_data
    @categories = tutorial_categories
  end

  def tutorial_detail
    # Tutorial detail page
    @slug = params[:slug]
    @tutorial = tutorials_data.find { |t| t[:slug] == @slug }

    if @tutorial.nil?
      redirect_to tutorials_path
      return
    end

    @related_tutorials = tutorials_data
      .reject { |t| t[:slug] == @slug }
      .select { |t| (t[:categories] & @tutorial[:categories]).any? }
      .first(3)
  end

  def submit_contact
    # Process the contact form submission
    @name = params[:name]
    @email = params[:email]
    @phone = params[:phone]
    @subject = params[:subject]
    @message = params[:message]

    # Here you would typically send an email or save to database
    # For now, we'll just redirect with a flash message

    # Example of sending an email (commented out)
    # ContactMailer.contact_email(@name, @email, @phone, @subject, @message).deliver_now

    # Example of saving to database (commented out)
    # ContactMessage.create(
    #   name: @name,
    #   email: @email,
    #   phone: @phone,
    #   subject: @subject,
    #   message: @message
    # )

    # Flash a success message and redirect
    flash[:success] = "Thank you for your message! We'll get back to you soon."
    redirect_to contact_path
  end

  private

  # Helper methods for Help Center

  def help_categories
    [
      {
        title: "Getting Started",
        slug: "getting-started",
        icon: "rocket",
        description: "Learn the basics of using our platform",
        articles: [
          {
            title: "Creating Your Account",
            slug: "creating-your-account",
            excerpt: "Learn how to create and set up your account",
            content: help_article_content("creating-your-account"),
            tags: ["account", "setup", "beginner"]
          },
          {
            title: "Setting Up Your Profile",
            slug: "setting-up-your-profile",
            excerpt: "Customize your profile to showcase your brand",
            content: help_article_content("setting-up-your-profile"),
            tags: ["profile", "setup", "beginner"]
          },
          {
            title: "Navigating the Dashboard",
            slug: "navigating-the-dashboard",
            excerpt: "Learn how to use the dashboard to manage your account",
            content: help_article_content("navigating-the-dashboard"),
            tags: ["dashboard", "navigation", "beginner"]
          }
        ]
      },
      {
        title: "Account Management",
        slug: "account-management",
        icon: "user-circle",
        description: "Manage your account settings and preferences",
        articles: [
          {
            title: "Updating Your Password",
            slug: "updating-your-password",
            excerpt: "Learn how to update your password and secure your account",
            content: help_article_content("updating-your-password"),
            tags: ["account", "security", "password"]
          },
          {
            title: "Managing Notification Settings",
            slug: "managing-notification-settings",
            excerpt: "Customize your notification preferences",
            content: help_article_content("managing-notification-settings"),
            tags: ["notifications", "settings", "preferences"]
          },
          {
            title: "Subscription and Billing",
            slug: "subscription-and-billing",
            excerpt: "Manage your subscription plans and billing information",
            content: help_article_content("subscription-and-billing"),
            tags: ["billing", "subscription", "payment"]
          }
        ]
      },
      {
        title: "Products and Services",
        slug: "products-and-services",
        icon: "shopping-bag",
        description: "Learn about our products and services",
        articles: [
          {
            title: "Product Features Overview",
            slug: "product-features-overview",
            excerpt: "Explore the features of our products",
            content: help_article_content("product-features-overview"),
            tags: ["features", "products", "overview"]
          },
          {
            title: "Service Packages",
            slug: "service-packages",
            excerpt: "Learn about our service packages and what they include",
            content: help_article_content("service-packages"),
            tags: ["services", "packages", "pricing"]
          },
          {
            title: "Product Comparison",
            slug: "product-comparison",
            excerpt: "Compare our different products to find the right one for you",
            content: help_article_content("product-comparison"),
            tags: ["products", "comparison", "features"]
          }
        ]
      },
      {
        title: "Troubleshooting",
        slug: "troubleshooting",
        icon: "support",
        description: "Solve common issues and get help",
        articles: [
          {
            title: "Common Login Issues",
            slug: "common-login-issues",
            excerpt: "Solutions for common login problems",
            content: help_article_content("common-login-issues"),
            tags: ["login", "troubleshooting", "account"]
          },
          {
            title: "Payment Processing Issues",
            slug: "payment-processing-issues",
            excerpt: "Resolve issues with payment processing",
            content: help_article_content("payment-processing-issues"),
            tags: ["payment", "troubleshooting", "billing"]
          },
          {
            title: "Mobile App Troubleshooting",
            slug: "mobile-app-troubleshooting",
            excerpt: "Fix common issues with our mobile app",
            content: help_article_content("mobile-app-troubleshooting"),
            tags: ["mobile", "app", "troubleshooting"]
          }
        ]
      },
      {
        title: "Security and Privacy",
        slug: "security-and-privacy",
        icon: "shield-check",
        description: "Learn about our security measures and privacy policies",
        articles: [
          {
            title: "Data Protection Measures",
            slug: "data-protection-measures",
            excerpt: "How we protect your data",
            content: help_article_content("data-protection-measures"),
            tags: ["security", "data", "protection"]
          },
          {
            title: "Privacy Policy Explained",
            slug: "privacy-policy-explained",
            excerpt: "Understanding our privacy policy in simple terms",
            content: help_article_content("privacy-policy-explained"),
            tags: ["privacy", "policy", "data"]
          },
          {
            title: "Two-Factor Authentication",
            slug: "two-factor-authentication",
            excerpt: "Set up two-factor authentication for enhanced security",
            content: help_article_content("two-factor-authentication"),
            tags: ["security", "2fa", "authentication"]
          }
        ]
      }
    ]
  end

  def popular_articles
    [
      {
        title: "Creating Your Account",
        category: "Getting Started",
        slug: "creating-your-account",
        category_slug: "getting-started",
        views: 1245
      },
      {
        title: "Subscription and Billing",
        category: "Account Management",
        slug: "subscription-and-billing",
        category_slug: "account-management",
        views: 982
      },
      {
        title: "Two-Factor Authentication",
        category: "Security and Privacy",
        slug: "two-factor-authentication",
        category_slug: "security-and-privacy",
        views: 876
      },
      {
        title: "Common Login Issues",
        category: "Troubleshooting",
        slug: "common-login-issues",
        category_slug: "troubleshooting",
        views: 754
      }
    ]
  end

  def recent_articles
    [
      {
        title: "Mobile App Troubleshooting",
        category: "Troubleshooting",
        slug: "mobile-app-troubleshooting",
        category_slug: "troubleshooting",
        date: 3.days.ago
      },
      {
        title: "Product Comparison",
        category: "Products and Services",
        slug: "product-comparison",
        category_slug: "products-and-services",
        date: 5.days.ago
      },
      {
        title: "Managing Notification Settings",
        category: "Account Management",
        slug: "managing-notification-settings",
        category_slug: "account-management",
        date: 7.days.ago
      },
      {
        title: "Privacy Policy Explained",
        category: "Security and Privacy",
        slug: "privacy-policy-explained",
        category_slug: "security-and-privacy",
        date: 10.days.ago
      }
    ]
  end

  def related_articles(article)
    # Find articles with matching tags
    all_articles = help_categories.flat_map { |cat| cat[:articles] }
    all_articles.select do |art|
      art[:slug] != article[:slug] && (art[:tags] & article[:tags]).any?
    end.first(3)
  end

  def tutorial_categories
    [
      { name: "Getting Started", slug: "getting-started", icon: "rocket" },
      { name: "Development", slug: "development", icon: "code" },
      { name: "Design", slug: "design", icon: "brush" },
      { name: "Marketing", slug: "marketing", icon: "chart" },
      { name: "Analytics", slug: "analytics", icon: "chart-bar" },
      { name: "Security", slug: "security", icon: "shield" }
    ]
  end

  def tutorials_data
    [
      {
        title: "Building Your First E-commerce Store",
        slug: "building-first-ecommerce-store",
        excerpt: "Learn how to set up and launch your first online store with our platform in less than a day.",
        description: "This comprehensive tutorial will guide you through the process of setting up your first e-commerce store from scratch. You'll learn how to configure products, set up payment processing, customize your storefront, and launch your business online.",
        image: "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80",
        author: {
          name: "Sarah Johnson",
          avatar: "https://randomuser.me/api/portraits/women/44.jpg",
          role: "E-commerce Specialist"
        },
        duration: "45 minutes",
        level: "Beginner",
        categories: ["getting-started", "development"],
        tags: ["e-commerce", "setup", "beginner"],
        published_at: 2.weeks.ago,
        steps: [
          {
            title: "Setting Up Your Account",
            content: "Create your account and verify your email address to get started with our platform.",
            image: "https://images.unsplash.com/photo-1517292987719-0369a794ec0f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Configuring Your Store",
            content: "Set up your store name, logo, and basic information to establish your brand identity.",
            image: "https://images.unsplash.com/photo-1460925895917-afdab827c52f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Adding Products",
            content: "Learn how to add products, set prices, and manage inventory for your online store.",
            image: "https://images.unsplash.com/photo-1472851294608-062f824d29cc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Setting Up Payments",
            content: "Configure payment gateways to start accepting payments from customers worldwide.",
            image: "https://images.unsplash.com/photo-1563013544-824ae1b704d3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Launching Your Store",
            content: "Final checks and steps to take before launching your store to the public.",
            image: "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          }
        ],
        featured: true
      },
      {
        title: "Advanced SEO Techniques for E-commerce",
        slug: "advanced-seo-techniques",
        excerpt: "Boost your store's visibility with these proven SEO strategies specifically designed for e-commerce websites.",
        description: "Discover advanced SEO techniques that will help your e-commerce store rank higher in search results. This tutorial covers keyword research, on-page optimization, technical SEO, and content strategies specifically tailored for online stores.",
        image: "https://images.unsplash.com/photo-1571171637578-41bc2dd41cd2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80",
        author: {
          name: "Michael Chen",
          avatar: "https://randomuser.me/api/portraits/men/32.jpg",
          role: "SEO Specialist"
        },
        duration: "60 minutes",
        level: "Advanced",
        categories: ["marketing", "analytics"],
        tags: ["seo", "marketing", "traffic"],
        published_at: 1.month.ago,
        steps: [
          {
            title: "Keyword Research for E-commerce",
            content: "Learn how to find the most valuable keywords for your products and categories.",
            image: "https://images.unsplash.com/photo-1432888498266-38ffec3eaf0a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "On-Page Optimization",
            content: "Optimize your product pages, category pages, and content for better search visibility.",
            image: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Technical SEO for E-commerce",
            content: "Address technical issues that could be holding back your store's search performance.",
            image: "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Content Strategy",
            content: "Develop a content strategy that drives traffic and converts visitors into customers.",
            image: "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          }
        ],
        featured: false
      },
      {
        title: "Designing a User-Friendly Mobile Experience",
        slug: "user-friendly-mobile-experience",
        excerpt: "Create a seamless mobile shopping experience that keeps customers coming back to your store.",
        description: "Mobile shopping is on the rise, and having a user-friendly mobile experience is crucial for e-commerce success. This tutorial will show you how to optimize your store for mobile users, improve navigation, and increase conversion rates on smaller screens.",
        image: "https://images.unsplash.com/photo-1555421689-491a97ff2040?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80",
        author: {
          name: "Emma Rodriguez",
          avatar: "https://randomuser.me/api/portraits/women/63.jpg",
          role: "UX Designer"
        },
        duration: "30 minutes",
        level: "Intermediate",
        categories: ["design", "development"],
        tags: ["mobile", "ux", "design"],
        published_at: 3.weeks.ago,
        steps: [
          {
            title: "Mobile UX Principles",
            content: "Understand the key principles of mobile user experience design for e-commerce.",
            image: "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Optimizing Navigation",
            content: "Create intuitive navigation that works well on small screens and helps users find products quickly.",
            image: "https://images.unsplash.com/photo-1559028012-481c04fa702d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Mobile-Friendly Product Pages",
            content: "Design product pages that look great and convert well on mobile devices.",
            image: "https://images.unsplash.com/photo-1607252650355-f7fd0460ccdb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Streamlining Checkout",
            content: "Optimize the checkout process for mobile to reduce abandonment and increase conversions.",
            image: "https://images.unsplash.com/photo-1616077168079-7e09a677fb2c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          }
        ],
        featured: true
      },
      {
        title: "Implementing Secure Payment Processing",
        slug: "secure-payment-processing",
        excerpt: "Learn how to set up secure payment processing to protect your customers and your business.",
        description: "Security is paramount when handling customer payments. This tutorial will guide you through the process of implementing secure payment processing on your e-commerce store, covering encryption, PCI compliance, fraud prevention, and best practices.",
        image: "https://images.unsplash.com/photo-1563013544-824ae1b704d3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80",
        author: {
          name: "David Wilson",
          avatar: "https://randomuser.me/api/portraits/men/75.jpg",
          role: "Security Expert"
        },
        duration: "50 minutes",
        level: "Advanced",
        categories: ["security", "development"],
        tags: ["payments", "security", "pci"],
        published_at: 2.months.ago,
        steps: [
          {
            title: "Understanding Payment Security",
            content: "Learn the fundamentals of payment security and why it's critical for your business.",
            image: "https://images.unsplash.com/photo-1563013544-824ae1b704d3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Setting Up SSL/TLS",
            content: "Secure your website with proper SSL/TLS implementation to protect customer data.",
            image: "https://images.unsplash.com/photo-1614064641938-3bbee52942c7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "PCI DSS Compliance",
            content: "Ensure your store meets Payment Card Industry Data Security Standards (PCI DSS).",
            image: "https://images.unsplash.com/photo-1563013544-824ae1b704d3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Fraud Prevention",
            content: "Implement fraud prevention measures to protect your business from fraudulent transactions.",
            image: "https://images.unsplash.com/photo-1607275121002-8eb99dca38b8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          }
        ],
        featured: false
      },
      {
        title: "Creating Effective Product Photography",
        slug: "effective-product-photography",
        excerpt: "Learn how to take stunning product photos that showcase your items and drive sales.",
        description: "High-quality product photography is essential for e-commerce success. This tutorial will teach you how to take professional-looking product photos using simple equipment, edit them effectively, and optimize them for your online store.",
        image: "https://images.unsplash.com/photo-1542038784456-1ea8e935640e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80",
        author: {
          name: "Jessica Lee",
          avatar: "https://randomuser.me/api/portraits/women/23.jpg",
          role: "Product Photographer"
        },
        duration: "40 minutes",
        level: "Beginner",
        categories: ["design", "marketing"],
        tags: ["photography", "products", "images"],
        published_at: 1.week.ago,
        steps: [
          {
            title: "Setting Up Your Photography Space",
            content: "Create a simple but effective photography setup using affordable equipment.",
            image: "https://images.unsplash.com/photo-1542038784456-1ea8e935640e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Lighting Techniques",
            content: "Master basic lighting techniques to showcase your products in the best possible way.",
            image: "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Composition and Angles",
            content: "Learn how to compose your shots and find the best angles for different types of products.",
            image: "https://images.unsplash.com/photo-1505682634904-d7c8d95cdc50?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Editing Your Photos",
            content: "Simple editing techniques to enhance your product photos and make them look professional.",
            image: "https://images.unsplash.com/photo-1572044162444-ad60f128bdea?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Optimizing Images for Web",
            content: "Prepare your images for your online store to ensure fast loading times and high quality.",
            image: "https://images.unsplash.com/photo-1461749280684-dccba630e2f6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          }
        ],
        featured: true
      },
      {
        title: "Setting Up Email Marketing Automation",
        slug: "email-marketing-automation",
        excerpt: "Automate your email marketing to nurture leads, recover abandoned carts, and boost sales.",
        description: "Email marketing is one of the most effective channels for e-commerce businesses. This tutorial will show you how to set up automated email campaigns that drive sales, including welcome sequences, abandoned cart recovery, post-purchase follow-ups, and more.",
        image: "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80",
        author: {
          name: "Robert Taylor",
          avatar: "https://randomuser.me/api/portraits/men/52.jpg",
          role: "Email Marketing Specialist"
        },
        duration: "55 minutes",
        level: "Intermediate",
        categories: ["marketing", "analytics"],
        tags: ["email", "automation", "marketing"],
        published_at: 3.days.ago,
        steps: [
          {
            title: "Setting Up Your Email Platform",
            content: "Choose and configure the right email marketing platform for your e-commerce business.",
            image: "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Creating a Welcome Sequence",
            content: "Design an effective welcome email sequence to introduce new subscribers to your brand.",
            image: "https://images.unsplash.com/photo-1516905041604-7935af78f572?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Abandoned Cart Recovery",
            content: "Set up automated emails to recover abandoned carts and complete more sales.",
            image: "https://images.unsplash.com/photo-1586892478025-2b5472316bf4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Post-Purchase Follow-ups",
            content: "Create automated follow-up emails to encourage reviews, repeat purchases, and referrals.",
            image: "https://images.unsplash.com/photo-1512314889357-e157c22f938d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          },
          {
            title: "Measuring and Optimizing",
            content: "Track the performance of your email campaigns and optimize for better results.",
            image: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80"
          }
        ],
        featured: false
      }
    ]
  end

  def help_article_content(slug)
    case slug
    when "creating-your-account"
      <<~MARKDOWN
        # Creating Your Account

        Creating an account on our platform is quick and easy. Follow these simple steps to get started.

        ## Step 1: Visit the Sign-Up Page

        Navigate to our website and click on the "Sign Up" button in the top-right corner of the page.

        ## Step 2: Enter Your Information

        Fill in the required fields:
        - Email address
        - Password (at least 8 characters with a mix of letters, numbers, and symbols)
        - Full name
        - Company name (optional)

        ## Step 3: Verify Your Email

        After submitting the form, you'll receive a verification email. Click on the link in the email to verify your account.

        ## Step 4: Complete Your Profile

        Once your email is verified, you'll be prompted to complete your profile. Add a profile picture, bio, and other relevant information.

        ## Step 5: Set Your Preferences

        Configure your account settings and notification preferences to customize your experience.

        ## Troubleshooting

        If you encounter any issues during the sign-up process, please check the following:
        - Make sure your email address is entered correctly
        - Check your spam folder for the verification email
        - Ensure your password meets the minimum requirements

        For additional help, contact our support team at support@example.com.
      MARKDOWN
    when "setting-up-your-profile"
      <<~MARKDOWN
        # Setting Up Your Profile

        A complete profile helps you get the most out of our platform and builds trust with other users.

        ## Profile Picture

        Upload a clear, professional profile picture. This helps others recognize you and adds credibility to your account.

        ## Bio and Description

        Write a concise bio that highlights your expertise, interests, and what you hope to achieve on our platform.

        ## Contact Information

        Add your preferred contact methods. You can control the visibility of this information in your privacy settings.

        ## Social Media Links

        Connect your social media accounts to expand your network and make it easier for others to find you.

        ## Skills and Expertise

        List your skills and areas of expertise to help others understand your strengths and to improve matching algorithms.

        ## Privacy Settings

        Review and adjust your privacy settings to control who can see your profile information and how you can be contacted.

        ## Profile Completion

        Aim for 100% profile completion to maximize your visibility and opportunities on the platform.

        ## Regular Updates

        Keep your profile up-to-date with your latest achievements, skills, and contact information.
      MARKDOWN
    when "navigating-the-dashboard"
      <<~MARKDOWN
        # Navigating the Dashboard

        The dashboard is your command center for managing all aspects of your account and activities.

        ## Dashboard Overview

        When you log in, you'll land on the main dashboard page, which provides a summary of your account status, recent activities, and important notifications.

        ## Main Navigation

        The main navigation menu is located on the left side of the screen and includes the following sections:
        - Home
        - Projects
        - Messages
        - Calendar
        - Reports
        - Settings

        ## Quick Actions

        The quick actions bar at the top of the dashboard allows you to:
        - Create new items
        - Search the platform
        - Access notifications
        - View your profile

        ## Widgets and Cards

        The dashboard displays various widgets and cards that provide at-a-glance information about:
        - Recent activities
        - Upcoming deadlines
        - Performance metrics
        - Team updates

        ## Customizing Your Dashboard

        You can customize your dashboard by:
        - Rearranging widgets
        - Adding or removing cards
        - Setting default views
        - Adjusting display preferences

        ## Mobile Dashboard

        The mobile version of the dashboard provides a streamlined experience optimized for smaller screens while maintaining access to all essential features.

        ## Keyboard Shortcuts

        Learn keyboard shortcuts to navigate the dashboard more efficiently:
        - `Ctrl + H`: Go to Home
        - `Ctrl + P`: Go to Projects
        - `Ctrl + M`: Go to Messages
        - `Ctrl + S`: Go to Settings
      MARKDOWN
    when "updating-your-password"
      <<~MARKDOWN
        # Updating Your Password

        Regularly updating your password is an important security practice. Here's how to change your password on our platform.

        ## From the Settings Page

        1. Log in to your account
        2. Click on your profile picture in the top-right corner
        3. Select "Settings" from the dropdown menu
        4. Navigate to the "Security" tab
        5. Click on "Change Password"

        ## Password Requirements

        Your new password must meet the following requirements:
        - At least 8 characters long
        - Include at least one uppercase letter
        - Include at least one lowercase letter
        - Include at least one number
        - Include at least one special character

        ## Verification

        You'll need to enter your current password to verify your identity before setting a new password.

        ## After Changing Your Password

        After successfully changing your password:
        - You'll receive an email confirmation
        - All other devices will be logged out
        - You'll need to log in again with your new password

        ## Forgot Your Password?

        If you've forgotten your current password:
        1. Click on "Forgot Password" on the login page
        2. Enter your email address
        3. Follow the instructions in the password reset email

        ## Password Security Tips

        - Don't reuse passwords across different sites
        - Consider using a password manager
        - Change your password every 3-6 months
        - Never share your password with others
      MARKDOWN
    when "managing-notification-settings"
      <<~MARKDOWN
        # Managing Notification Settings

        Customize your notification preferences to stay informed without being overwhelmed.

        ## Accessing Notification Settings

        1. Log in to your account
        2. Click on your profile picture in the top-right corner
        3. Select "Settings" from the dropdown menu
        4. Navigate to the "Notifications" tab

        ## Email Notifications

        Control which updates are sent to your email:
        - Account security alerts
        - New messages
        - Updates from your network
        - Marketing and promotional content
        - Newsletter

        ## Push Notifications

        If you use our mobile app, you can customize push notifications:
        - Real-time alerts
        - Daily summaries
        - Weekly digests

        ## In-App Notifications

        Manage notifications that appear within the platform:
        - Activity on your content
        - Mentions and tags
        - System announcements
        - Reminders

        ## Notification Frequency

        Choose how often you receive notifications:
        - Immediately
        - Daily digest
        - Weekly summary

        ## Do Not Disturb

        Set up "Do Not Disturb" hours when you won't receive notifications.

        ## Unsubscribing

        You can unsubscribe from marketing emails by:
        - Clicking the "Unsubscribe" link in any marketing email
        - Turning off marketing notifications in your settings

        ## Notification Channels

        Select your preferred notification channels:
        - Email
        - SMS
        - Push notifications
        - In-app notifications
      MARKDOWN
    else
      <<~MARKDOWN
        # #{slug.titleize}

        This is a placeholder article for "#{slug.titleize}". The content for this article is currently being developed.

        ## Overview

        This article will provide detailed information about #{slug.titleize.downcase}.

        ## Key Points

        - Important point 1
        - Important point 2
        - Important point 3

        ## Step-by-Step Guide

        1. First step
        2. Second step
        3. Third step

        ## Additional Resources

        - Resource 1
        - Resource 2
        - Resource 3

        ## FAQ

        **Q: Frequently asked question 1?**
        A: Answer to question 1.

        **Q: Frequently asked question 2?**
        A: Answer to question 2.

        **Q: Frequently asked question 3?**
        A: Answer to question 3.

        ## Contact Support

        If you need further assistance, please contact our support team at support@example.com.
      MARKDOWN
    end
  end
end
