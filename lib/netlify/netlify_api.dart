import 'dart:convert';
import 'dart:io';

import 'package:process_run/shell.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/env_setter.dart';

/// List of Netlify APIs
/// For more information, see
///
/// https://open-api.netlify.com
///
/// https://docs.netlify.com/api/get-started/
class NetlifyApi {
  /// Sure Method to Get Correct Account Slug
  static Future<void> getAccountSlug(
      {required Function(String? slug) onDone}) async {
    await NetlifyApi.getCurrentUser(onDone: (String? account) async {
      if (account != null) {
        final Map<String, dynamic> user =
            json.decode(account) as Map<String, dynamic>;
        // compute here slug
        // if no slug default is full name
        // if no full name default is email
        onDone(user['slug'] as String?);
      }
    });
  }

  /// Create a New Site with Randomness
  /// ```
  /// {
  /// "id": "d377266e-aa4b-47e7-abf6-f5233922e4fc",
  /// "site_id": "d377266e-aa4b-47e7-abf6-f5233922e4fc",
  /// "plan": "nf_team_dev",
  /// "ssl_plan": null,
  /// "premium": false,
  /// "claimed": true,
  /// "name": "competent-mccarthy-43fc0e",
  /// "custom_domain": null,
  /// "domain_aliases": [],
  /// "password": null,
  /// "notification_email": null,
  /// "url": "http://competent-mccarthy-43fc0e.netlify.app",
  /// "admin_url": "https://app.netlify.com/sites/competent-mccarthy-43fc0e",
  /// "deploy_id": "",
  /// "build_id": "",
  /// "deploy_url": "http://6138c6114673a7de4780452f--competent-mccarthy-43fc0e.netlify.app",
  /// "state": "current",
  /// "screenshot_url": null,
  /// "created_at": "2021-09-08T14:17:53.374Z",
  /// "updated_at": "2021-09-08T14:17:53.471Z",
  /// "user_id": "612678e8344e1c080c32c51b",
  /// "error_message": null,
  /// "ssl": false,
  /// "ssl_url": "https://competent-mccarthy-43fc0e.netlify.app",
  /// "force_ssl": null,
  /// "ssl_status": null,
  /// "max_domain_aliases": 100,
  /// "build_settings": {},
  /// "processing_settings": {
  ///   "css": {
  ///     "bundle": true,
  ///     "minify": true
  ///   },
  ///   "js": {
  ///     "bundle": true,
  ///     "minify": true
  ///   },
  ///   "images": {
  ///     "optimize": true
  ///   },
  ///   "html": {
  ///     "pretty_urls": true
  ///   },
  ///   "skip": true,
  ///   "ignore_html_forms": false
  /// },
  /// "prerender": null,
  /// "prerender_headers": null,
  /// "deploy_hook": null,
  /// "published_deploy": null,
  /// "managed_dns": true,
  /// "jwt_secret": null,
  /// "jwt_roles_path": "app_metadata.authorization.roles",
  /// "account_slug": "hugoforbes88",
  /// "account_name": "Billionaires Code",
  /// "account_type": "Starter",
  /// "capabilities": {
  ///   "title": "Netlify Team Free",
  ///   "asset_acceleration": true,
  ///   "form_processing": true,
  ///   "cdn_propagation": "partial",
  ///   "build_node_pool": "buildbot-external-ssd",
  ///   "domain_aliases": true,
  ///   "secure_site": false,
  ///   "prerendering": true,
  ///   "proxying": true,
  ///   "ssl": "custom",
  ///   "rate_cents": 0,
  ///   "yearly_rate_cents": 0,
  ///   "ipv6_domain": "cdn.makerloop.com",
  ///   "branch_deploy": true,
  ///   "managed_dns": true,
  ///   "geo_ip": true,
  ///   "split_testing": true,
  ///   "id": "nf_team_dev",
  ///   "cdn_tier": "reg"
  /// },
  /// "dns_zone_id": null,
  /// "identity_instance_id": null,
  /// "use_functions": null,
  /// "use_edge_handlers": null,
  /// "parent_user_id": null,
  /// "automatic_tls_provisioning": null,
  /// "disabled": null,
  /// "lifecycle_state": "active",
  /// "id_domain": "d377266e-aa4b-47e7-abf6-f5233922e4fc.netlify.app",
  /// "use_lm": null,
  /// "build_image": "focal",
  /// "automatic_tls_provisioning_expired": false,
  /// "analytics_instance_id": null,
  /// "functions_region": null,
  /// "functions_config": {
  ///   "site_created_at": "2021-09-08T14:17:53.374Z"
  /// },
  /// "plugins": [],
  /// "account_subdomain": null,
  /// "functions_env": {},
  /// "cdp_enabled": true,
  /// "default_domain": "competent-mccarthy-43fc0e.netlify.app"
  ///
  /// ```
  static Future<void> createRandomSite(
      {required Function(String? siteDetails) onDone}) async {
    const String command = 'ntl';
    final List<String> args = <String>['api', 'createSite'];
    final String? cmdPathOrNull = whichSync(command,
        environment: <String, String>{'PATH': PathEnv.get()});
    final StringBuffer output = StringBuffer();
    String? siteDetails;
    if (cmdPathOrNull != null) {
      try {
        Process.run(
          cmdPathOrNull,
          args,
          runInShell: true,
        ).asStream().listen((ProcessResult process) async {
          output.write(process.stdout.toString());
        }, onDone: () {
          siteDetails = output.toString();
          onDone(siteDetails);
        });
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    } else {
      CommandFailedException.log(
          'Command Not Found', 'Cannot Execute The Command');
    }
  }

  /// Create New Site
  /// > @param optional String? `data`
  /// > Example Data to Be Passed:
  /// ```dart
  ///  final Map<String, Map<String, String>> data =
  ///  <String, Map<String, String>>{
  ///       'body': <String, String>{
  ///         'name': 'Quatrokantos',
  ///         'custom_domain': 'quatrokantos.app'
  ///       }
  /// };
  /// final String bodyStr = json.encode(data);
  /// ```
  ///  For Detailed API Docs: https://open-api.netlify.com/#operation/createSite
  static Future<void> createSite(String? data,
      {required Function(String? siteDetails) onDone,
      required Function(String? errorMessage) onError}) async {
    const String command = 'ntl';
    final List<String> args = <String>[];
    final RegExp errorReg = RegExp(r'\bJSONHTTPError\b');
    args.add('api');
    args.add('createSite');
    if (data != null) {
      args.add('--data');
      args.add(data);
    }
    final String? cmdPathOrNull = whichSync(command,
        environment: <String, String>{'PATH': PathEnv.get()});
    final StringBuffer output = StringBuffer();
    final StringBuffer errorBuffer = StringBuffer();
    String? siteDetails;
    String? errorMessage;
    final StringBuffer networkErrorBuffer = StringBuffer();
    final RegExp netRegex = RegExp(r'\bFetchError\b');

    if (cmdPathOrNull != null) {
      try {
        Process.run(
          cmdPathOrNull,
          args,
          runInShell: true,
          environment: (Platform.isWindows)
              ? null
              : <String, String>{'PATH': PathEnv.get()},
        ).asStream().listen((ProcessResult process) async {
          final String _stdout = process.stdout.toString().trim();
          final String _stderr = process.stderr.toString().trim();
          if (_stdout != '') {
            output.write(_stdout);
          }
          if (errorReg.hasMatch(_stderr)) {
            errorBuffer.write(_stderr);
          }
          if (netRegex.hasMatch(_stderr)) {
            networkErrorBuffer.write('No Internet Connection');
          }
        }, onDone: () {
          siteDetails = output.toString();
          errorMessage = errorBuffer.toString();

          if (siteDetails != '') {
            onDone(siteDetails);
          }

          if (networkErrorBuffer.toString() != '') {
            // No Internet Error
            errorMessage = networkErrorBuffer.toString();
          }
          if (errorMessage != '') {
            onError(errorMessage);
          }
        });
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    } else {
      CommandFailedException.log(
          'Command Not Found', 'Cannot Execute The Command');
    }
  }

  /// Delete Site with id
  /// - @param `id`
  /// - @param `onDone`
  /// - @return `void`
  ///
  ///  onDOne returns `empty string` if `Successful`
  ///
  ///  If it did return `any messages` then it `fails`
  ///  For Detailed API Docs: https://open-api.netlify.com/#operation/deleteSite
  static Future<void> deleteSite(String id,
      {required Function(String? message) onDone}) async {
    final String jsonData = '''
{"site_id": "$id"}
'''
        .trim();
    const String command = 'ntl';
    final List<String> args = <String>[
      'api',
      'deleteSite',
      '--data',
      jsonData,
    ];
    final String? cmdPathOrNull = whichSync(command,
        environment: <String, String>{'PATH': PathEnv.get()});
    final StringBuffer output = StringBuffer();
    String? message;
    if (cmdPathOrNull != null) {
      try {
        Process.run(
          cmdPathOrNull,
          args,
          runInShell: true,
        ).asStream().listen((ProcessResult process) async {
          output.write(process.stdout.toString());
        }, onDone: () {
          message = output.toString();
          onDone(message);
        });
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    } else {
      CommandFailedException.log(
          'Command Not Found', 'Cannot Execute The Command');
    }
  }

  /// Create New Site with account Slug and data
  ///
  ///  For Detailed API Docs: https://open-api.netlify.com/#operation/createSiteInTeam
  ///  - @param `accountSlug`
  ///  - @param `data`
  ///  - @param `onDone`
  ///
  ///  Example Usage:
  ///  ```
  /// final Map<String, String> body = <String, String>{
  ///    'name': 'Quatrokantos',
  ///    'custom_domain': 'quatrokantos.app'
  ///  };
  ///  final String bodyStr = json.encode(body);
  ///  NetlifyApi.createSiteInTeam('hugoforbes88', bodyStr,
  ///      onDone: (String? output) {
  ///    print(output);
  ///  });
  ///  ```
  /// - @return `void`
  ///
  /// onDOne returns `empty string` if `failed`
  ///
  /// Example Response :
  /// ```
  /// {
  /// "id": "d377266e-aa4b-47e7-abf6-f5233922e4fc",
  /// "site_id": "d377266e-aa4b-47e7-abf6-f5233922e4fc",
  /// "plan": "nf_team_dev",
  /// "ssl_plan": null,
  /// "premium": false,
  /// "claimed": true,
  /// "name": "competent-mccarthy-43fc0e",
  /// "custom_domain": null,
  /// "domain_aliases": [],
  /// "password": null,
  /// "notification_email": null,
  /// "url": "http://competent-mccarthy-43fc0e.netlify.app",
  /// "admin_url": "https://app.netlify.com/sites/competent-mccarthy-43fc0e",
  /// "deploy_id": "",
  /// "build_id": "",
  /// "deploy_url": "http://6138c6114673a7de4780452f--competent-mccarthy-43fc0e.netlify.app",
  /// "state": "current",
  /// "screenshot_url": null,
  /// "created_at": "2021-09-08T14:17:53.374Z",
  /// "updated_at": "2021-09-08T14:17:53.471Z",
  /// "user_id": "612678e8344e1c080c32c51b",
  /// "error_message": null,
  /// "ssl": false,
  /// "ssl_url": "https://competent-mccarthy-43fc0e.netlify.app",
  /// "force_ssl": null,
  /// "ssl_status": null,
  /// "max_domain_aliases": 100,
  /// "build_settings": {},
  /// "processing_settings": {
  ///   "css": {
  ///     "bundle": true,
  ///     "minify": true
  ///   },
  ///   "js": {
  ///     "bundle": true,
  ///     "minify": true
  ///   },
  ///   "images": {
  ///     "optimize": true
  ///   },
  ///   "html": {
  ///     "pretty_urls": true
  ///   },
  ///   "skip": true,
  ///   "ignore_html_forms": false
  /// },
  /// "prerender": null,
  /// "prerender_headers": null,
  /// "deploy_hook": null,
  /// "published_deploy": null,
  /// "managed_dns": true,
  /// "jwt_secret": null,
  /// "jwt_roles_path": "app_metadata.authorization.roles",
  /// "account_slug": "hugoforbes88",
  /// "account_name": "Billionaires Code",
  /// "account_type": "Starter",
  /// "capabilities": {
  ///   "title": "Netlify Team Free",
  ///   "asset_acceleration": true,
  ///   "form_processing": true,
  ///   "cdn_propagation": "partial",
  ///   "build_node_pool": "buildbot-external-ssd",
  ///   "domain_aliases": true,
  ///   "secure_site": false,
  ///   "prerendering": true,
  ///   "proxying": true,
  ///   "ssl": "custom",
  ///   "rate_cents": 0,
  ///   "yearly_rate_cents": 0,
  ///   "ipv6_domain": "cdn.makerloop.com",
  ///   "branch_deploy": true,
  ///   "managed_dns": true,
  ///   "geo_ip": true,
  ///   "split_testing": true,
  ///   "id": "nf_team_dev",
  ///   "cdn_tier": "reg"
  /// },
  /// "dns_zone_id": null,
  /// "identity_instance_id": null,
  /// "use_functions": null,
  /// "use_edge_handlers": null,
  /// "parent_user_id": null,
  /// "automatic_tls_provisioning": null,
  /// "disabled": null,
  /// "lifecycle_state": "active",
  /// "id_domain": "d377266e-aa4b-47e7-abf6-f5233922e4fc.netlify.app",
  /// "use_lm": null,
  /// "build_image": "focal",
  /// "automatic_tls_provisioning_expired": false,
  /// "analytics_instance_id": null,
  /// "functions_region": null,
  /// "functions_config": {
  ///   "site_created_at": "2021-09-08T14:17:53.374Z"
  /// },
  /// "plugins": [],
  /// "account_subdomain": null,
  /// "functions_env": {},
  /// "cdp_enabled": true,
  /// "default_domain": "competent-mccarthy-43fc0e.netlify.app"
  ///
  /// ```

  /// Create New Site
  /// > @param optional String? `data`
  /// > If We returned `Empty String` api call failed
  /// > Example Data to Be Passed:
  /// ```dart
  ///  final Map<String, Map<String, String>> data =
  ///  <String, Map<String, String>>{
  ///       'body': <String, String>{
  ///         'name': 'Quatrokantos',
  ///         'custom_domain': 'quatrokantos.app'
  ///       }
  /// };
  /// final String bodyStr = json.encode(data);
  /// ```
  static Future<void> createSiteInTeam(String account_slug, String? data,
      {required Function(String? siteDetails) onDone}) async {
    const String command = 'ntl';
    final List<String> args = <String>[];
    String noData;
    args.add('api');
    args.add('createSiteInTeam');
    args.add('--data');

    if (data != null) {
      final Map<String, dynamic> payload = <String, dynamic>{
        'account_slug': account_slug,
        'body': json.decode(data)
      };

      args.add(json.encode(payload));
    } else {
      noData = '''
{"account_slug": "$account_slug"}
'''
          .trim();
      args.add(noData);
    }
    final String? cmdPathOrNull = whichSync(command,
        environment: <String, String>{'PATH': PathEnv.get()});
    final StringBuffer output = StringBuffer();
    String? siteDetails;
    if (cmdPathOrNull != null) {
      try {
        Process.run(
          cmdPathOrNull,
          args,
          runInShell: true,
        ).asStream().listen((ProcessResult process) async {
          output.write(process.stdout.toString());
        }, onDone: () {
          siteDetails = output.toString();
          onDone(siteDetails);
        });
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    } else {
      CommandFailedException.log(
          'Command Not Found', 'Cannot Execute The Command');
    }
  }

  /// Get Current Authenticated User Details
  ///
  /// For Detailed API Docs: https://open-api.netlify.com/#operation/getCurrentUser
  /// ```
  /// {
  ///  "id": "612678e8344e1c080c32c51b",
  ///  "uid": null,
  ///  "full_name": "Hugo Forbes",
  ///  "avatar": "https://secure.gravatar.com/avatar/899eec7bef7f8ba0da2dd026f6979a73?s=30",
  ///  "avatar_url": "https://secure.gravatar.com/avatar/899eec7bef7f8ba0da2dd026f6979a73?s=30",
  ///  "email": "hugoforbes88@gmail.com",
  ///  "affiliate_id": "",
  ///  "site_count": 0,
  ///  "created_at": "2021-08-25T17:07:52.387Z",
  ///  "last_login": "2021-09-06T20:07:39.880Z",
  ///  "login_providers": [
  ///    "password"
  ///  ],
  ///  "onboarding_progress": {
  ///    "slides": "closed"
  ///  },
  ///  "slug": null,
  ///  "sandbox": false,
  ///  "connected_accounts": {},
  ///  "pending_email": null,
  ///  "has_pending_email_verification": false,
  ///  "mfa_enabled": false,
  ///  "saml_account_id": "",
  ///  "saml_slug": null,
  ///  "preferred_account_id": "",
  ///  "tracking_id": "612678e8344e1c080c32c51b"
  ///   }
  /// ```
  static Future<void> getCurrentUser(
      {required Function(String? userStr) onDone}) async {
    const String command = 'ntl';
    final List<String> args = <String>['api', 'getCurrentUser'];
    final String? cmdPathOrNull = whichSync(command,
        environment: <String, String>{'PATH': PathEnv.get()});
    final StringBuffer output = StringBuffer();
    String? userStr;
    if (cmdPathOrNull != null) {
      try {
        Process.run(
          cmdPathOrNull,
          args,
          runInShell: true,
        ).asStream().listen((ProcessResult process) async {
          output.write(process.stdout.toString());
        }, onDone: () {
          userStr = output.toString();
          onDone(userStr);
        });
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    } else {
      CommandFailedException.log(
          'Command Not Found', 'Cannot Execute The Command');
    }
  }

  /// Get Current Authenticated User details
  ///
  /// For Detailed API Docs: https://open-api.netlify.com/#operation/getAccount
  /// ```
  /// {
  /// "name": "Billionaires Code",
  /// "slug": "hugoforbes88",
  /// "capabilities": {
  ///   "bandwidth": {
  ///     "included": 107374182400,
  ///     "used": 0
  ///   },
  ///   "collaborators": {
  ///     "included": 1,
  ///     "used": 1
  ///   },
  ///   "custom_prerender": {
  ///     "included": true
  ///   },
  ///   "trusted_committers": {
  ///     "included": true
  ///   },
  ///   "concurrent_builds": {
  ///     "included": 1,
  ///     "max": 1,
  ///     "used": 0
  ///   },
  ///   "build_minutes": {
  ///     "included": 300,
  ///     "used": 0
  ///   },
  ///   "deploy_url_hooks": {
  ///     "included": true
  ///   },
  ///   "sites": {
  ///     "included": 500,
  ///     "used": 0
  ///   },
  ///   "analytics": {
  ///     "included": false
  ///   },
  ///   "domains": {
  ///     "included": 10,
  ///     "used": 0
  ///   }
  /// },
  /// "site_access": "all",
  /// "billing_name": "hugoforbes88",
  /// "billing_email": "hugoforbes88@gmail.com",
  /// "billing_details": null,
  /// "billing_period": null,
  /// "user_capabilities": {
  ///   "accounts": {
  ///     "c": true,
  ///     "r": true,
  ///     "u": true,
  ///     "d": true
  ///   },
  ///   "sites": {
  ///     "c": true,
  ///     "r": true,
  ///     "u": true,
  ///     "d": true
  ///   },
  ///   "deploys": {
  ///     "c": true,
  ///     "r": true,
  ///     "u": true,
  ///     "d": true
  ///   },
  ///   "members": {
  ///     "c": true,
  ///     "r": true,
  ///     "u": true,
  ///     "d": true
  ///   },
  ///   "billing": {
  ///     "c": true,
  ///     "r": true,
  ///     "u": true,
  ///     "d": true
  ///   }
  /// },
  /// "roles_allowed": [
  ///   "Collaborator"
  /// ],
  /// "created_at": "2021-08-25T17:07:52.409Z",
  /// "updated_at": "2021-08-25T17:09:37.271Z",
  /// "site_password": null,
  /// "site_jwt_secret": null,
  /// "saml_config": null,
  /// "deploy_notifications_per_repo": true,
  /// "payments_gateway_name": null,
  /// "site_env": null,
  /// "lifecycle_state": "active",
  /// "lifecycle_state_reason": null,
  /// "weeks_past_due": null,
  /// "days_until_disabled": null,
  /// "current_billing_period_start": "2021-08-25T00:00:00.000-07:00",
  /// "next_billing_period_start": "2021-09-25T00:00:00.000-07:00",
  /// "support_level": "0",
  /// "support_priority": 0,
  /// "extra_concurrent_builds": 0,
  /// "members_count": 1,
  /// "id": "612678e8344e1c080c32c51c",
  /// "payment_method_id": "",
  /// "type_name": "Starter",
  /// "type_id": "5d2464889e975c00bab54e55",
  /// "type_slug": "starter",
  /// "monthly_seats_addon_dollar_price": "15.0",
  /// "owner_ids": [
  ///   "612678e8344e1c080c32c51b"
  /// ],
  /// "site_capabilities": {
  ///   "title": "Netlify Team Free",
  ///   "asset_acceleration": true,
  ///   "form_processing": true,
  ///   "cdn_propagation": "partial",
  ///   "build_node_pool": "buildbot-external-ssd",
  ///   "domain_aliases": true,
  ///   "secure_site": false,
  ///   "prerendering": true,
  ///   "proxying": true,
  ///   "ssl": "custom",
  ///   "rate_cents": 0,
  ///   "yearly_rate_cents": 0,
  ///   "ipv6_domain": "cdn.makerloop.com",
  ///   "branch_deploy": true,
  ///   "managed_dns": true,
  ///   "geo_ip": true,
  ///   "split_testing": true,
  ///   "id": "nf_team_dev"
  /// },
  /// "saml_enabled": null,
  /// "default": true,
  /// "has_builds": false,
  /// "enforce_saml": "not_enforced",
  /// "team_logo_url": null,
  /// "gitlab_self_hosted_config": null,
  /// "github_enterprise_config": null
  ///}
  /// ```
  ///
  static Future<void> getAccount(String account_slug,
      {required Function(String? accountDetails) onDone}) async {
    final String jsonData = '''
{"account_id": "$account_slug"}
'''
        .trim();
    const String command = 'ntl';
    final List<String> args = <String>['api', 'getAccount', '--data', jsonData];
    final String? cmdPathOrNull = whichSync(command,
        environment: <String, String>{'PATH': PathEnv.get()});
    final StringBuffer output = StringBuffer();
    String? accountDetails;
    if (cmdPathOrNull != null) {
      try {
        Process.run(
          cmdPathOrNull,
          args,
          runInShell: true,
        ).asStream().listen((ProcessResult process) async {
          output.write(process.stdout.toString());
        }, onDone: () {
          accountDetails = output.toString();
          onDone(accountDetails);
        });
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    } else {
      CommandFailedException.log(
          'Command Not Found', 'Cannot Execute The Command');
    }
  }

  /// Get All Sites
  ///
  /// For more information, please visit https://open-api.netlify.com/#operation/listSites
  /// ```
  /// [
  ///  {
  ///    "id": "4306bc94-5cec-4b49-904d-293aa061df70",
  ///    "site_id": "4306bc94-5cec-4b49-904d-293aa061df70",
  ///    "plan": "nf_team_dev",
  ///    "ssl_plan": null,
  ///    "premium": false,
  ///    "claimed": true,
  ///    "name": "compassionate-khorana-3b73e7",
  ///    "custom_domain": null,
  ///    "domain_aliases": [],
  ///    "password": null,
  ///    "notification_email": null,
  ///    "url": "http://compassionate-khorana-3b73e7.netlify.app",
  ///    "admin_url": "https://app.netlify.com/sites/compassionate-khorana-3b73e7",
  ///    "deploy_id": "",
  ///    "build_id": "",
  ///    "deploy_url": "http://613906e2dc2d5900abeedf2b--compassionate-khorana-3b73e7.netlify.app",
  ///    "state": "current",
  ///    "screenshot_url": null,
  ///    "created_at": "2021-09-08T18:52:23.003Z",
  ///    "updated_at": "2021-09-08T18:52:23.106Z",
  ///    "user_id": "612678e8344e1c080c32c51b",
  ///    "error_message": null,
  ///    "ssl": false,
  ///    "ssl_url": "https://compassionate-khorana-3b73e7.netlify.app",
  ///    "force_ssl": null,
  ///    "ssl_status": null,
  ///    "max_domain_aliases": 100,
  ///    "build_settings": {},
  ///    "processing_settings": {
  ///      "css": {
  ///        "bundle": true,
  ///        "minify": true
  ///      },
  ///      "js": {
  ///        "bundle": true,
  ///        "minify": true
  ///      },
  ///      "images": {
  ///        "optimize": true
  ///      },
  ///      "html": {
  ///        "pretty_urls": true
  ///      },
  ///      "skip": true,
  ///      "ignore_html_forms": false
  ///    },
  ///    "prerender": null,
  ///    "prerender_headers": null,
  ///    "deploy_hook": null,
  ///    "published_deploy": null,
  ///    "managed_dns": true,
  ///    "jwt_secret": null,
  ///    "jwt_roles_path": "app_metadata.authorization.roles",
  ///    "account_slug": "hugoforbes88",
  ///    "account_name": "Billionaires Code",
  ///    "account_type": "Starter",
  ///    "capabilities": {
  ///      "title": "Netlify Team Free",
  ///      "asset_acceleration": true,
  ///      "form_processing": true,
  ///      "cdn_propagation": "partial",
  ///      "build_node_pool": "buildbot-external-ssd",
  ///      "domain_aliases": true,
  ///      "secure_site": false,
  ///      "prerendering": true,
  ///      "proxying": true,
  ///      "ssl": "custom",
  ///      "rate_cents": 0,
  ///      "yearly_rate_cents": 0,
  ///      "ipv6_domain": "cdn.makerloop.com",
  ///      "branch_deploy": true,
  ///      "managed_dns": true,
  ///      "geo_ip": true,
  ///      "split_testing": true,
  ///      "id": "nf_team_dev",
  ///      "cdn_tier": "reg"
  ///    },
  ///    "dns_zone_id": null,
  ///    "identity_instance_id": null,
  ///    "use_functions": null,
  ///    "use_edge_handlers": null,
  ///    "parent_user_id": null,
  ///    "automatic_tls_provisioning": null,
  ///    "disabled": null,
  ///    "lifecycle_state": "active",
  ///    "id_domain": "4306bc94-5cec-4b49-904d-293aa061df70.netlify.app",
  ///    "use_lm": null,
  ///    "build_image": "focal",
  ///    "automatic_tls_provisioning_expired": false,
  ///    "analytics_instance_id": null,
  ///    "functions_region": null,
  ///    "functions_config": {
  ///      "site_created_at": "2021-09-08T18:52:23.003Z"
  ///    },
  ///    "plugins": [],
  ///    "account_subdomain": null,
  ///    "functions_env": {},
  ///    "cdp_enabled": true,
  ///    "default_domain": "compassionate-khorana-3b73e7.netlify.app"
  ///  }
  ///]
  /// ```
  static Future<void> listSites(
      {required Function(String? sitesList) onDone}) async {
    const String command = 'ntl';
    final List<String> args = <String>['api', 'listSites'];
    final String? cmdPathOrNull = whichSync(command,
        environment: <String, String>{'PATH': PathEnv.get()});
    final StringBuffer output = StringBuffer();
    String? sitesList;
    if (cmdPathOrNull != null) {
      try {
        Process.run(
          cmdPathOrNull,
          args,
          runInShell: true,
        ).asStream().listen((ProcessResult process) async {
          output.write(process.stdout.toString());
        }, onDone: () {
          sitesList = output.toString();
          onDone(sitesList);
        });
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    } else {
      CommandFailedException.log(
          'Command Not Found', 'Cannot Execute The Command');
    }
  }

  /// List Site Deploy Keys
  ///
  /// We Can Create a New Github API Calls
  ///
  /// to Sumit this Key on Specific Repo
  ///
  /// Important For Private Keys to Work
  ///
  /// For More Details visit: https://open-api.netlify.com/#operation/listDeployKeys
  ///
  /// Example Response:
  /// ```shell
  /// [
  ///  {
  ///    "id": "6139089e777ab600e9a24bcd",
  ///    "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDaJAbIZnbYiIif+eJNSMthfIgBVIO3oTaQAYxRygmNhiiHwOLwf2HNqpr7kC6yxQAi+X6RIquuO547ZLLBII3OfNhoWyh+2+6Rpjkk400WXMkHxT8HFg4B7yn8k00JVt5p3j/OCUkTo4t6jMBF8dh1phZ6YdoalHASbamIq1B+45nJQKqCtUbTt4ZgHC+5dFVFmvGByDChMlO7Rd9/l4JBtaDfhKW3rz1dBQkpASwkZrd5vc/aNUaUMqCo0ts4w73I9sugCFPI9j0+xmGqh9r0jke3lcniNyBc3Ty7ZYMIoHHbaPOQz6IaeB1oZooxZZ6ErglSPQvSnOku2IuODRSR12KMH+wPpH9eGH5K5Y2jcNKctF5mNi0TcF++jP5eBikgBuRo0PfXxK/zXX7cIESer3DASNOzoKRKjLLEbAaKKOZpgenLfNNcQfp+Dgzav0PmsgVjhlsLFcQHPc5G6hnBMw1nDKLsBugaqVKrN/xPF++4GHHEHQpLvhCjKPbvBRAkCbDBx839GlGSQ8FD0Vtf2gThFQtQDL6XesAzg+O5e8wzj8boX3dndE7KOUIraQXlgpoUocjC84DtiNfDuXWJ+UZeCZzugMgvurx1awZb8m2xNIxvArbKQM8bbwZMzhtwk4j1XoX71X0F7iSekMY+3knnprcZAXv0VjqlaEoL2Q==",
  ///    "created_at": "2021-09-08T19:01:50.897Z"
  ///  }
  ///]
  /// ```
  static Future<void> listDeployKeys(
      {required Function(String? accountDetails) onDone}) async {
    const String command = 'ntl';
    final List<String> args = <String>['api', 'listDeployKeys'];
    final String? cmdPathOrNull = whichSync(command,
        environment: <String, String>{'PATH': PathEnv.get()});
    final StringBuffer output = StringBuffer();
    String? accountDetails;
    if (cmdPathOrNull != null) {
      try {
        Process.run(
          cmdPathOrNull,
          args,
          runInShell: true,
        ).asStream().listen((ProcessResult process) async {
          output.write(process.stdout.toString());
        }, onDone: () {
          accountDetails = output.toString();
          onDone(accountDetails);
        });
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    } else {
      CommandFailedException.log(
          'Command Not Found', 'Cannot Execute The Command');
    }
  }

  /// Create Deploy Keys
  ///
  /// Important For Private Repo to Work
  ///
  /// For more Details visit: https://open-api.netlify.com/#operation/createDeployKey
  ///
  /// Example Response:
  /// ```
  /// {
  ///  "id": "61390cce760dfa0a4959734b",
  ///  "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCUBQHof7gqBAIn/hy8K72Otyt3xfwDoecgNU9plsCs+KBzHlOiOR8dnS/GsMLqKHl0BRYfyPFMeXqCGy7+wLpMquoTRSo/notOv2vUSp/e0v3kuPxX0Syi43ZBbEW+EiYla5MekEToIk4bkGjRbkayuie7tQs4+oU8MCE0uPdAGp5KL1MMsAe2PyFXn/urmsP6bpDdQ44sEDu68HNdWtyK/2yGTqwDxLCpcTENJakNRHjjYhUcm3PzjL6Wy3B+ntADhvvhX/68vPepiKFEvxuu1vQY9Nfw3HdvcwJ0dUNvb6kT5s2Maqaclhek3dN1MdESZZAR6BgiACqwfRaICyfb+NI816wwf91ClDVUUPgE7E81EYMTq3ac8MchLO4ApeW4fOiemXBkaocn8r6sYUwU4OAAVSv8MgXSUkT0wA9t2cmhgIhRToEPgIyqM/kPViR7P4ds+y+vqwxeukpBHa4RFEjWMJxq52gg8ApU0/ii9YglnjQt9Z5KfM+Ui0eJFfcYQZZe63GXcx8IMrhC1JDM7EyRRyhcJlWQOtoDi/LIr1apyqjaTsC99ivrqqx4LwP9gmPkQBXsK998dVnI49cjPLYmsGVFMW4FHjrkKUUPTl6FQhNGMtvLpl3L6Y2HG1M1ACzV9D/5+WCnGEGbGz2/OWscfJIIxE8Hz4YS3RaoHw==",
  ///  "created_at": "2021-09-08T19:19:42.440Z"
  ///}
  /// ```
  static Future<void> createDeployKey(
      {required Function(String? deploy_key) onDone}) async {
    const String command = 'ntl';
    final List<String> args = <String>[
      'api',
      'createDeployKey',
    ];
    final String? cmdPathOrNull = whichSync(command,
        environment: <String, String>{'PATH': PathEnv.get()});
    final StringBuffer output = StringBuffer();
    String? deploy_key;
    if (cmdPathOrNull != null) {
      try {
        Process.run(
          cmdPathOrNull,
          args,
          runInShell: true,
        ).asStream().listen((ProcessResult process) async {
          output.write(process.stdout.toString());
        }, onDone: () {
          deploy_key = output.toString();
          onDone(deploy_key);
        });
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    } else {
      CommandFailedException.log(
          'Command Not Found', 'Cannot Execute The Command');
    }
  }

  /// Delete Deploy Key
  /// - @param `key_id` : The deploy key id
  /// - @return `""` can be ignored
  ///
  /// For more Details visit: https://open-api.netlify.com/#operation/deleteDeployKey
  static Future<void> deleteDeployKey(String keyId,
      {required Function(String? accountDetails) onDone}) async {
    final String jsonData = '''
{"key_id": "$keyId"}
'''
        .trim();
    const String command = 'ntl';
    final List<String> args = <String>[
      'api',
      'deleteDeployKey',
      '--data',
      jsonData
    ];
    final String? cmdPathOrNull = whichSync(command,
        environment: <String, String>{'PATH': PathEnv.get()});
    final StringBuffer output = StringBuffer();
    String? accountDetails;
    if (cmdPathOrNull != null) {
      try {
        Process.run(
          cmdPathOrNull,
          args,
          runInShell: true,
        ).asStream().listen((ProcessResult process) async {
          output.write(process.stdout.toString());
        }, onDone: () {
          accountDetails = output.toString();
          onDone(accountDetails);
        });
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    } else {
      CommandFailedException.log(
          'Command Not Found', 'Cannot Execute The Command');
    }
  }

  /// Get Deploy Key by ID
  /// - @param `key_id` : The deploy key id
  /// - @return `""` can be ignored
  ///
  /// For more Details visit: https://open-api.netlify.com/#operation/getDeployKey
  ///
  /// ```json
  /// {
  ///  "id": "61390cce760dfa0a4959734b",
  ///  "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCUBQHof7gqBAIn/hy8K72Otyt3xfwDoecgNU9plsCs+KBzHlOiOR8dnS/GsMLqKHl0BRYfyPFMeXqCGy7+wLpMquoTRSo/notOv2vUSp/e0v3kuPxX0Syi43ZBbEW+EiYla5MekEToIk4bkGjRbkayuie7tQs4+oU8MCE0uPdAGp5KL1MMsAe2PyFXn/urmsP6bpDdQ44sEDu68HNdWtyK/2yGTqwDxLCpcTENJakNRHjjYhUcm3PzjL6Wy3B+ntADhvvhX/68vPepiKFEvxuu1vQY9Nfw3HdvcwJ0dUNvb6kT5s2Maqaclhek3dN1MdESZZAR6BgiACqwfRaICyfb+NI816wwf91ClDVUUPgE7E81EYMTq3ac8MchLO4ApeW4fOiemXBkaocn8r6sYUwU4OAAVSv8MgXSUkT0wA9t2cmhgIhRToEPgIyqM/kPViR7P4ds+y+vqwxeukpBHa4RFEjWMJxq52gg8ApU0/ii9YglnjQt9Z5KfM+Ui0eJFfcYQZZe63GXcx8IMrhC1JDM7EyRRyhcJlWQOtoDi/LIr1apyqjaTsC99ivrqqx4LwP9gmPkQBXsK998dVnI49cjPLYmsGVFMW4FHjrkKUUPTl6FQhNGMtvLpl3L6Y2HG1M1ACzV9D/5+WCnGEGbGz2/OWscfJIIxE8Hz4YS3RaoHw==",
  ///  "created_at": "2021-09-08T19:19:42.440Z"
  ///}
  /// ```
  static Future<void> getDeployKey(String keyId,
      {required Function(String? accountDetails) onDone}) async {
    final String jsonData = '''
{"key_id": "$keyId"}
'''
        .trim();
    const String command = 'ntl';
    final List<String> args = <String>[
      'api',
      'deleteDeployKey',
      '--data',
      jsonData
    ];
    final String? cmdPathOrNull = whichSync(command,
        environment: <String, String>{'PATH': PathEnv.get()});
    final StringBuffer output = StringBuffer();
    String? accountDetails;
    if (cmdPathOrNull != null) {
      try {
        Process.run(
          cmdPathOrNull,
          args,
          runInShell: true,
        ).asStream().listen((ProcessResult process) async {
          output.write(process.stdout.toString());
        }, onDone: () {
          accountDetails = output.toString();
          onDone(accountDetails);
        });
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    } else {
      CommandFailedException.log(
          'Command Not Found', 'Cannot Execute The Command');
    }
  }

  /// Get Site Details
  ///  - @param  `siteId`
  ///  - @param `onDone`
  ///  - @return `void`
  ///
  /// For more etails visit: https://open-api.netlify.com/#operation/getSite
  ///  > onDone Callback Ouput Example:
  /// ```
  /// {
  ///  "id": "4306bc94-5cec-4b49-904d-293aa061df70",
  ///  "site_id": "4306bc94-5cec-4b49-904d-293aa061df70",
  ///  "plan": "nf_team_dev",
  ///  "ssl_plan": null,
  ///  "premium": false,
  ///  "claimed": true,
  ///  "name": "compassionate-khorana-3b73e7",
  ///  "custom_domain": null,
  ///  "domain_aliases": [],
  ///  "password": null,
  ///  "notification_email": null,
  ///  "url": "http://compassionate-khorana-3b73e7.netlify.app",
  ///  "admin_url": "https://app.netlify.com/sites/compassionate-khorana-3b73e7",
  ///  "deploy_id": "",
  ///  "build_id": "",
  ///  "deploy_url": "http://61390edca5c9a50bf795a42a--compassionate-khorana-3b73e7.netlify.app",
  ///  "state": "current",
  ///  "screenshot_url": null,
  ///  "created_at": "2021-09-08T18:52:23.003Z",
  ///  "updated_at": "2021-09-08T18:52:23.106Z",
  ///  "user_id": "612678e8344e1c080c32c51b",
  ///  "error_message": null,
  ///  "ssl": false,
  ///  "ssl_url": "https://compassionate-khorana-3b73e7.netlify.app",
  ///  "force_ssl": null,
  ///  "ssl_status": null,
  ///  "max_domain_aliases": 100,
  ///  "build_settings": {},
  ///  "processing_settings": {
  ///    "css": {
  ///      "bundle": true,
  ///      "minify": true
  ///    },
  ///    "js": {
  ///      "bundle": true,
  ///      "minify": true
  ///    },
  ///    "images": {
  ///      "optimize": true
  ///    },
  ///    "html": {
  ///      "pretty_urls": true
  ///    },
  ///    "skip": true,
  ///    "ignore_html_forms": false
  ///  },
  ///  "prerender": null,
  ///  "prerender_headers": null,
  ///  "deploy_hook": null,
  ///  "published_deploy": null,
  ///  "managed_dns": true,
  ///  "jwt_secret": null,
  ///  "jwt_roles_path": "app_metadata.authorization.roles",
  ///  "account_slug": "hugoforbes88",
  ///  "account_name": "Billionaires Code",
  ///  "account_type": "Starter",
  ///  "capabilities": {
  ///    "title": "Netlify Team Free",
  ///    "asset_acceleration": true,
  ///    "form_processing": true,
  ///    "cdn_propagation": "partial",
  ///    "build_node_pool": "buildbot-external-ssd",
  ///    "domain_aliases": true,
  ///    "secure_site": false,
  ///    "prerendering": true,
  ///    "proxying": true,
  ///    "ssl": "custom",
  ///    "rate_cents": 0,
  ///    "yearly_rate_cents": 0,
  ///    "ipv6_domain": "cdn.makerloop.com",
  ///    "branch_deploy": true,
  ///    "managed_dns": true,
  ///    "geo_ip": true,
  ///    "split_testing": true,
  ///    "id": "nf_team_dev",
  ///    "cdn_tier": "reg"
  ///  },
  ///  "dns_zone_id": null,
  ///  "identity_instance_id": null,
  ///  "use_functions": null,
  ///  "use_edge_handlers": null,
  ///  "parent_user_id": null,
  ///  "automatic_tls_provisioning": null,
  ///  "disabled": null,
  ///  "lifecycle_state": "active",
  ///  "id_domain": "4306bc94-5cec-4b49-904d-293aa061df70.netlify.app",
  ///  "use_lm": null,
  ///  "build_image": "focal",
  ///  "automatic_tls_provisioning_expired": false,
  ///  "analytics_instance_id": null,
  ///  "functions_region": null,
  ///  "functions_config": {
  ///    "site_created_at": "2021-09-08T18:52:23.003Z"
  ///  },
  ///  "plugins": [],
  ///  "account_subdomain": null,
  ///  "functions_env": {},
  ///  "cdp_enabled": true,
  ///  "default_domain": "compassionate-khorana-3b73e7.netlify.app"
  ///}
  /// ```
  static Future<void> getSite(String siteId,
      {required Function(String? accountDetails) onDone}) async {
    final String jsonData = '''
{"site_id": "$siteId"}
'''
        .trim();
    const String command = 'ntl';
    final List<String> args = <String>['api', 'getSite', '--data', jsonData];
    final String? cmdPathOrNull = whichSync(command,
        environment: <String, String>{'PATH': PathEnv.get()});
    final StringBuffer output = StringBuffer();
    String? accountDetails;
    if (cmdPathOrNull != null) {
      try {
        Process.run(
          cmdPathOrNull,
          args,
          runInShell: true,
        ).asStream().listen((ProcessResult process) async {
          output.write(process.stdout.toString());
        }, onDone: () {
          accountDetails = output.toString();
          onDone(accountDetails);
        });
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    } else {
      CommandFailedException.log(
          'Command Not Found', 'Cannot Execute The Command');
    }
  }

  /// Change the Site Name
  ///  - @param  `siteId`
  ///  - @param `siteName`
  ///  - @param `onDone`
  ///  - @return `void`
  ///  > onDone Callback Ouput Example:
  /// ```dart
  /// {
  ///  "id": "4306bc94-5cec-4b49-904d-293aa061df70",
  ///  "site_id": "4306bc94-5cec-4b49-904d-293aa061df70",
  ///  "plan": "nf_team_dev",
  ///  "ssl_plan": null,
  ///  "premium": false,
  ///  "claimed": true,
  ///  "name": "pitamelark",
  ///  "custom_domain": null,
  ///  "domain_aliases": [],
  ///  "password": null,
  ///  "notification_email": null,
  ///  "url": "http://pitamelark.netlify.app",
  ///  "admin_url": "https://app.netlify.com/sites/pitamelark",
  ///  "deploy_id": "",
  ///  "build_id": "",
  ///  "deploy_url": "http://61391edc760dfa1f67597237--pitamelark.netlify.app",
  ///  "state": "current",
  ///  "screenshot_url": null,
  ///  "created_at": "2021-09-08T18:52:23.003Z",
  ///  "updated_at": "2021-09-08T20:36:44.437Z",
  ///  "user_id": "612678e8344e1c080c32c51b",
  ///  "error_message": null,
  ///  "ssl": false,
  ///  "ssl_url": "https://pitamelark.netlify.app",
  ///  "force_ssl": null,
  ///  "ssl_status": null,
  ///  "max_domain_aliases": 100,
  ///  "build_settings": {},
  ///  "processing_settings": {
  ///    "css": {
  ///      "bundle": true,
  ///      "minify": true
  ///    },
  ///    "js": {
  ///      "bundle": true,
  ///      "minify": true
  ///    },
  ///    "images": {
  ///      "optimize": true
  ///    },
  ///    "html": {
  ///      "pretty_urls": true
  ///    },
  ///    "skip": true,
  ///    "ignore_html_forms": false
  ///  },
  ///  "prerender": null,
  ///  "prerender_headers": null,
  ///  "deploy_hook": null,
  ///  "published_deploy": null,
  ///  "managed_dns": true,
  ///  "jwt_secret": null,
  ///  "jwt_roles_path": "app_metadata.authorization.roles",
  ///  "account_slug": "hugoforbes88",
  ///  "account_name": "Billionaires Code",
  ///  "account_type": "Starter",
  ///  "capabilities": {
  ///    "title": "Netlify Team Free",
  ///    "asset_acceleration": true,
  ///    "form_processing": true,
  ///    "cdn_propagation": "partial",
  ///    "build_node_pool": "buildbot-external-ssd",
  ///    "domain_aliases": true,
  ///    "secure_site": false,
  ///    "prerendering": true,
  ///    "proxying": true,
  ///    "ssl": "custom",
  ///    "rate_cents": 0,
  ///    "yearly_rate_cents": 0,
  ///    "ipv6_domain": "cdn.makerloop.com",
  ///    "branch_deploy": true,
  ///    "managed_dns": true,
  ///    "geo_ip": true,
  ///    "split_testing": true,
  ///    "id": "nf_team_dev",
  ///    "cdn_tier": "reg"
  ///  },
  ///  "dns_zone_id": null,
  ///  "identity_instance_id": null,
  ///  "use_functions": null,
  ///  "use_edge_handlers": null,
  ///  "parent_user_id": null,
  ///  "automatic_tls_provisioning": null,
  ///  "disabled": null,
  ///  "lifecycle_state": "active",
  ///  "id_domain": "4306bc94-5cec-4b49-904d-293aa061df70.netlify.app",
  ///  "use_lm": null,
  ///  "build_image": "focal",
  ///  "automatic_tls_provisioning_expired": false,
  ///  "analytics_instance_id": null,
  ///  "functions_region": null,
  ///  "functions_config": {
  ///    "site_created_at": "2021-09-08T18:52:23.003Z"
  ///  },
  ///  "plugins": [],
  ///  "account_subdomain": null,
  ///  "functions_env": {},
  ///  "cdp_enabled": true,
  ///  "default_domain": "pitamelark.netlify.app"
  ///}
  /// ```
  static Future<void> changeSiteName(String siteId, String name,
      {required Function(String? accountDetails) onDone}) async {
    final String jsonData = '''
{ "site_id": "$siteId", "body": {"name": "$name"} }
'''
        .trim();
    const String command = 'ntl';
    final List<String> args = <String>['api', 'updateSite', '--data', jsonData];
    final String? cmdPathOrNull = whichSync(command,
        environment: <String, String>{'PATH': PathEnv.get()});
    final StringBuffer output = StringBuffer();
    String? siteDetails;
    if (cmdPathOrNull != null) {
      try {
        Process.run(
          cmdPathOrNull,
          args,
          runInShell: true,
        ).asStream().listen((ProcessResult process) async {
          output.write(process.stdout.toString());
        }, onDone: () {
          siteDetails = output.toString();
          onDone(siteDetails);
        });
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    } else {
      CommandFailedException.log(
          'Command Not Found', 'Cannot Execute The Command');
    }
  }
}
