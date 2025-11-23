import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/privacy-policy/')({
  component: PrivacyPolicy,
})

function PrivacyPolicy() {
  return (
    <div className="px-6 py-8 bg-background max-w-3xl mx-auto font-sans text-foreground">
      <h1 className="text-3xl font-bold mb-6">Privacy Policy</h1>

      <p className="mb-4">
        This privacy policy applies to the Olalarm app (hereby referred to as
        "Application") for mobile devices that was created by Krzysztof Borowy
        (hereby referred to as "Service Provider") as a Free service. This
        service is intended for use "AS IS".
      </p>

      <h2 className="text-xl font-semibold mt-8 mb-2">
        Information Collection and Use
      </h2>

      <p className="mb-4">
        The Application collects information when you download and use it. This
        information may include:
      </p>

      <ul className="list-disc ml-6 mb-4 space-y-1">
        <li>Your device's Internet Protocol address (e.g. IP address)</li>
        <li>
          The pages of the Application that you visit, the time and date of your
          visit, the time spent on those pages
        </li>
        <li>The time spent on the Application</li>
        <li>The operating system you use on your mobile device</li>
      </ul>

      <p className="mb-4">
        The Application does not gather precise information about the location
        of your mobile device.
      </p>

      <p className="mb-4">
        The Service Provider may use the information you provided to contact you
        from time to time to provide important information, required notices,
        and marketing promotions.
      </p>

      <p className="mb-4">
        For a better experience while using the Application, the Service
        Provider may require you to provide certain personally identifiable
        information. This information will be retained and used as described in
        this privacy policy.
      </p>

      <h2 className="text-xl font-semibold mt-8 mb-2">Third Party Access</h2>

      <p className="mb-4">
        Only aggregated, anonymized data is periodically transmitted to external
        services to aid the Service Provider in improving the Application. The
        Service Provider may share your information with third parties in the
        ways described in this privacy statement.
      </p>

      <p className="mb-4">The Service Provider may disclose information:</p>

      <ul className="list-disc ml-6 mb-4 space-y-1">
        <li>
          as required by law, such as to comply with a subpoena or similar
          process;
        </li>
        <li>
          when disclosure is necessary to protect rights, safety, investigate
          fraud, or respond to a request;
        </li>
        <li>
          with trusted service providers who work on the Service Provider’s
          behalf and follow this privacy policy.
        </li>
      </ul>

      <h2 className="text-xl font-semibold mt-8 mb-2">Opt-Out Rights</h2>

      <p className="mb-4">
        You can stop all collection of information by uninstalling the
        Application. You may use standard uninstall processes available on your
        mobile device or app marketplace.
      </p>

      <h2 className="text-xl font-semibold mt-8 mb-2">Data Retention Policy</h2>

      <p className="mb-4">
        The Service Provider will retain user-provided data for as long as you
        use the Application and for a reasonable time thereafter. If you want
        the Service Provider to delete your data, contact{' '}
        <a href="mailto:apps@kborowy.com" className="underline text-primary">
          apps@kborowy.com
        </a>
        .
      </p>

      <h2 className="text-xl font-semibold mt-8 mb-2">Children</h2>

      <p className="mb-4">
        The Service Provider does not knowingly collect personally identifiable
        information from children under 13. Parents and guardians are encouraged
        to monitor Internet usage and guide children regarding sharing personal
        information.
      </p>

      <p className="mb-4">
        If you believe a child has provided personal information, please contact
        the Service Provider at{' '}
        <a href="mailto:apps@kborowy.com" className="underline text-primary">
          apps@kborowy.com
        </a>
        .
      </p>

      <h2 className="text-xl font-semibold mt-8 mb-2">Security</h2>

      <p className="mb-4">
        The Service Provider is committed to safeguarding your information and
        implements physical, electronic, and procedural safeguards.
      </p>

      <h2 className="text-xl font-semibold mt-8 mb-2">Changes</h2>

      <p className="mb-4">
        This Privacy Policy may be updated from time to time. The Service
        Provider will notify you by updating this page. Continued use
        constitutes acceptance of the changes.
      </p>

      <p className="mb-4">Effective date: 2025-11-23</p>

      <h2 className="text-xl font-semibold mt-8 mb-2">Your Consent</h2>

      <p className="mb-4">
        By using the Application, you consent to the processing of your
        information as described in this Privacy Policy.
      </p>

      <h2 className="text-xl font-semibold mt-8 mb-2">Contact Us</h2>

      <p className="mb-4">
        For any questions, contact:{' '}
        <a href="mailto:apps@kborowy.com" className="underline text-primary">
          apps@kborowy.com
        </a>
      </p>

      <hr className="my-8 border-border" />

      <p className="text-sm opacity-70">
        This privacy policy page was generated by{' '}
        <a
          href="https://app-privacy-policy-generator.nisrulz.com/"
          className="underline text-primary"
          target="_blank"
          rel="noopener noreferrer"
        >
          App Privacy Policy Generator
        </a>
      </p>
    </div>
  )
}
