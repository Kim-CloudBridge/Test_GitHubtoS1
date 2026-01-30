locals{
    policy_type     = {
        access_logs = "${data.aws_iam_policy_document.access_logs_policy.json}"
        cross_account = "${data.aws_iam_policy_document.allow_access_from_another_account.json}"
    }

}