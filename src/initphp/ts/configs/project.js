const PROJECT = {
    production: true,
    conf: 'configs',
    copy: {
        initphp: {
            config: {
                from: './configs/src/initphp/',
                to: 'configs/',
            },
            logos: {
                from: './extra/initphp/logos',
                to: 'logos/',
            },
            root: {
                from: './assets/initphp/copy/root',
                to: '',
            },
            php: {
                from: './src/initphp/php/',
                to: '',
            },
        },
    },
};

export default PROJECT;
